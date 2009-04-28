# coding: utf-8

require "fileutils"
require "rubygems/user_interaction"
require "rubygems/builder"

class Gem < Thor
  self.default_task(:package)

  desc "package", "Package the gem"
  def package
    load("rango.gemspec")
    FileUtils.mkdir_p(File.join(Dir.pwd, "pkg"))
    ::Gem::Builder.new(SPECIFICATION).build
    FileUtils.mv(SPECIFICATION.file_name, File.join(Dir.pwd, "pkg", SPECIFICATION.file_name))
  end

  desc "install", "Package and install the gem."
  def install
    self.package
    puts %x[sudo gem install #{Dir["pkg/*.gem"].last}]
  end

  desc "uninstall", "Uninstall the gem."
  def uninstall
    puts %x[sudo gem uninstall rango -a -x]
  end
end
