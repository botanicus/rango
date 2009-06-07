# encoding: utf-8

require "fileutils"
require "rubygems/user_interaction"
require "rubygems/builder"

class Gem < Thor
  self.default_task(:package)

  desc "package", "Package the gem"
  def package
    load("rango.gemspec")
    spec = Rango::SPECIFICATION
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
