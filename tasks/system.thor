# encoding: utf-8

require "rbconfig"
require "fileutils"
require_relative "../lib/rango/ext/platform"

# TODO: better logging (colours, more descriptive)
# TODO: refactoring
# TODO: --prefix & --no-root for install e. g. to $HOME etc
# TODO: --bindir --libdir
# TODO: vendor installation for project
# TODO: --datadir
# TODO: --dry-run
class System < Thor
  include RbConfig
  include FileUtils
  method_options env: false, suffix: true, prefix: true, dry_run: false
  desc "install", "Install Rango for #{CONFIG["prefix"]}"
  def install
    run_if_has_permissions do
      write_manifest do |manifest|
        puts "Installing libraries ..."
        cp_r "lib/rango",    install_dir
        manifest.puts(File.join(install_dir, "rango"))
        cp   "lib/rango.rb", install_dir
        manifest.puts(File.join(install_dir, "rango.rb"))
        puts "Installing stubs into share directory ..."
        mkdir share_dir rescue nil
        cp_r "stubs", share_dir
        manifest.puts(File.join(share_dir))
        puts "Installing executables ..."
        Dir["bin/*"].each do |path|
          binary = File.basename(path)
          cp path, executable_path(binary)
          File.open(executable_path(binary), "w") do |file|
            content = File.readlines(path)
            content[0] = shebang
            file.puts(content)
          end
          manifest.puts(executable_path(binary))
          system "chmod a+xr #{executable_path(binary)}"
        end
      end
      puts "", "You will need rack, extlib and path and for development also erubis (generators) and thor"
    end
  end

  desc "uninstall", "Uninstall Rango from #{CONFIG["prefix"]}"
  def uninstall
    run_if_has_permissions do
      if File.exist?(manifest)
        puts "Removed all files listed in manifest ..."
        self.manifest_uninstall
      else
        # TODO: y/n for continue - if suffix/prefix differ, see note at manual_uninstall
        puts "Manifest file doesn't exist, falling back to manual uninstallation"
        self.manual_uninstall
      end
    end
  end

  protected
  def manifest_uninstall
    File.readlines(manifest).each do |file|
      file.chomp!
      if File.file?(file)
        remove_file file
      elsif File.directory?(file)
        remove_file file
      end
    end
  end

  def remove_file(file)
    print "Removing #{file} ... "
    if File.file?(file)
      FileUtils.rm file
      puts "OK"
    elsif File.directory?(file)
      rm_r file
      puts "OK"
    else
      puts "Doesn't exist"
    end
  end

  # specify --[no]-prefix and --[no]-suffix options if they was used during installation
  def manual_uninstall
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

  def manifest
    File.join(share_dir, "MANIFEST")
  end

  def write_manifest(&block)
    mkdir_p File.dirname(manifest) rescue nil
    File.open(manifest, "w") do |file|
      block.call(file)
    end
    puts "Manifest saved"
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
