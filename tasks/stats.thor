# coding: utf-8

require "fileutils"
require "rubygems/builder"

class Stats < Thor
  desc "all", "Package ..."
  def all
    self.libs
    puts
    self.specs
    puts
    self.docs
  end

  def libs
    self.count(Dir.glob("lib/rango/**/*.rb") + ["lib/rango.rb"])
  end

  def specs
    self.count(Dir.glob("spec/rango/**/*.rb") + ["spec/rango.rb"])
  end

  def docs
    self.count(Dir.glob("README.textile"))
  end

  protected
  def count(files)
    puts %x[wc -l #{files.join(" ")}]
  end
end
