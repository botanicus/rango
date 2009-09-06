# encoding: utf-8

class Gem < Thor
  self.default_task(:package)

  def initialize
    require "fileutils"
    require "rubygems/user_interaction"
    require "rubygems/builder"
  end

  desc "package", "Package the gem"
  def package
    gemspec = File.read("rango.gemspec")
    spec = eval(gemspec)
    FileUtils.mkdir_p(File.join(Dir.pwd, "pkg"))
    ::Gem::Builder.new(spec).build
    FileUtils.mv(spec.file_name, File.join(Dir.pwd, "pkg", spec.file_name))
  end

  desc "install", "Package and install the gem."
  def install
    self.package
    puts %x[gem install #{Dir["pkg/*.gem"].last}]
  end

  desc "uninstall", "Uninstall the gem."
  def uninstall
    puts %x[gem uninstall rango -a -x]
  end
end

class Gemspec < Thor
  desc "generate", "Generate gemspec"
  def generate
    require_relative "../lib/rango"
    require "erb"
    File.open("rango.gemspec", "w") do |file|
      content = File.read("rango.gemspec.erb")
      file.puts(ERB.new(content).result)
    end
  end

  desc "validate", "Validate gemspec"
  def validate
    require "rubygems/specification"
    data = File.read("rango.gemspec")
    spec = nil

    if data !~ %r{!ruby/object:Gem::Specification}
      Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
    else
      spec = YAML.load(data)
    end

    spec.validate

    puts spec
    puts "OK"
  end
end
