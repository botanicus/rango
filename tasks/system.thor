# encoding: utf-8

require "rbconfig"
require "fileutils"
require_relative "../lib/rango/ext/platform"

# TODO: better logging (colours, more descriptive)
class System < Thor
  include RbConfig
  include FileUtils
  method_options env: false, suffix: true, prefix: true
  desc "install", "Install Rango for #{CONFIG["prefix"]}"
  def install
    run_if_has_permissions do
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
    end
  end

  desc "uninstall", "Uninstall Rango from #{CONFIG["prefix"]}"
  def uninstall
    run_if_has_permissions do
      puts "Uninstalling libraries ..."
      rm_r File.join(install_dir, "lib/rango")
      rm   File.join(install_dir, "lib/rango.rb")
      puts "Installing stubs into share directory ..."
      rm_r share_dir rescue nil
      puts "Installing executables ..."
      Dir["bin/*"].each do |path|
        binary = File.basename(path)
        rm executable_path(binary)
      end
    end
  end

  protected
  def run_if_has_permissions(&block)
    # TODO: find a better way, it won't work on Gobo Linux for example
    # TODO: what about windows & permissions?
    if Rango::Platform.unix? && ENV["USER"].eql?("root")
      puts "Running with options: #{options.inspect}"
      block.call
    else
      abort "You have to be root!"
    end
  end

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
    [(prefix if options.prefix?), binary, (suffix if options.suffix?)].join("")
  end

  def executable_path(binary)
    File.join(bin_dir, executable_name(binary))
  end

  def shebang
    if options.env?
      "#!/usr/bin/env #{CONFIG["exec_prefix"]} --disable-gems"
    else
      "#!/usr/bin/env #{CONFIG["RUBY_INSTALL_NAME"]} --disable-gems"
    end
  end
end
