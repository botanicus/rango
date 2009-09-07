# encoding: utf-8

require "rbconfig"
require "fileutils"
require_relative "../lib/rango/ext/platform"

class Install < Thor
  include RbConfig
  include FileUtils
  # TODO: rewrite shebang (see CONFIG)
  # TODO: --disable-gems to shebang
  desc "system", "Install Rango for #{CONFIG["prefix"]}"
  def system
    # TODO: what about windows?
    if Rango::Platform.unix? && ENV["USER"].eql?("root") # TODO: find a better way, it won't work on Gobo Linux for example
      puts "Installing libraries ..."
      cp_r "lib/rango",    install_dir
      cp   "lib/rango.rb", install_dir
      puts "Installing stubs into share directory ..."
      mkdir share_dir rescue nil
      cp_r "stubs", share_dir
      puts "Installing executables ..."
      Dir["bin/*"].each do |path|
        binary = File.basename(path)
        cp path, executable_path(binary)
        File.open(executable_path(binary), "w") do |file|
          content = File.readlines(path)
          content[0] = shebang
          file.puts(content)
        end
        sh "chmod a+xr #{executable_path(binary)}"
      end
    else
      abort "You have to be root!"
    end
  end

  protected
  def install_dir
    CONFIG["sitelibdir"]
  end

  def share_dir
    File.join(CONFIG["datadir"], "rango")
  end

  def bin_dir
    CONFIG["bindir"]
  end

  # macrango for macruby
  # rango1.9 for ruby1.9
  # TODO: --[no]-suffix and --[no]-prefix
  def executable_name(binary)
    suffix = CONFIG["configure_args"].match(/'--program-suffix=([^']+)'/)[1] rescue nil
    prefix = CONFIG["configure_args"].match(/'--program-prefix=([^']+)'/)[1] rescue nil
    [prefix, binary, suffix].join("")
  end

  def executable_path(binary)
    File.join(bin_dir, executable_name(binary))
  end

  def shebang
    "#!/usr/bin/env #{CONFIG["RUBY_INSTALL_NAME"]} --disable-gems"
    #"#!/usr/bin/env #{CONFIG["exec_prefix"]} --disable-gems" # TODO: options for it
  end
end
