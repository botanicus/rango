require "fileutils"
require "rubygems/builder"

class Stats < Thor
  desc "all", "Package ..."
  def all
    self.libs
    self.docs
  end
  
  def libs
    self.count(Dir.glob("lib/rango/**.rb") + ["lib/rango.rb"])
  end
  
  def docs
    self.count(Dir.glob("README.textile"))
  end
  
  protected
  def count(files)
    puts %x[wc -l #{files.join(" ")}]
  end
end