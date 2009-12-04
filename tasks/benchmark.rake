# encoding: utf-8

# http://github.com/somebee/rbench/tree/master
desc "Run all benchmarks"
task :bm do
  abort "Benchmarks doesn't work at the moment"
  require "rbench"
  Dir["#{Dir.pwd}/benchmarks/bm/*.rb"].each do |benchmark|
    load benchmark
  end
end
