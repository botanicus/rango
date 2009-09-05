# encoding: utf-8

# http://github.com/somebee/rbench/tree/master
class Benchmark < Thor
  def initialize
    require "rbench"
  end

  desc "all", "Run all benchmarks"
  def all
    Dir["#{Dir.pwd}/benchmarks/bm/*.rb"].each do |benchmark|
      load benchmark
    end
  end
end
