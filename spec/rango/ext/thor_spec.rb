# encoding: utf-8

require_relative "../../../lib/rango/ext/kernel"
require_relative "../../../lib/rango/ext/thor"

Rango::Tasks.hook do
  puts "First hook called!"
end

class Tasks < Rango::Tasks
end

describe Rango::Tasks do
  describe ".hook" do
    it "should inherit hooks" do
      Tasks.hooks.length.should eql(1)
    end
  end

  describe "#boot" do
    it "should boot Rango" do
      quiet { Tasks.new.boot(flat: true) }
      Rango.should be_loaded
    end
  end
end
