# encoding: utf-8

require "rbconfig"
require "rango/ext/platform"

module Rango
  module CLI
    include RbConfig
    extend RbConfig
    # TODO: yes?("You're fine?", default: true)
    def yes?(question)
      print "#{question} [Y/n] "
      values = {"y" => true, "n" => false}
      values.default = "y"
      input  = STDIN.readline.chomp.downcase
      values[input]
    end

    def ask(question)
      print "#{question} "
      STDIN.readline.chomp
    end

    def shebang(executable = rubypath, args)
      if Rango::Platform.linux?
        self.plain_shebang(executable, args)
      elsif Rango::Platform.osx?
        self.env_shebang(executable, args)
      else
        self.envargs_shebang(executable, args)
      end
    end

    def plain_shebang(executable = rubypath, args)
      "#!#{executable} #{args.join(" ")}".chomp(" ")
    end

    def env_shebang(executable = ruby_basename, args)
      "#!/usr/bin/env #{executable} #{args.join(" ")}".chomp(" ")
    end

    def envargs_shebang(executable = ruby_basename, args)
      system_envargs = %x(which envargs).chomp
      local_envargs = File.join(Rango.root, "bin", "envargs")
      envargs = [system_envargs, local_envargs].detect { |path| File.executable?(path) }
      raise "No envargs detected!" if envargs.nil?
      "#!#{envargs} #{executable} #{args.join(" ")}".chomp(" ")
    end

    #
    def rubypath
      File.join(CONFIG["bindir"], CONFIG["RUBY_INSTALL_NAME"])
    end

    def ruby_basename
      CONFIG["RUBY_INSTALL_NAME"]
    end
  end
end
