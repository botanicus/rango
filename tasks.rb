#!/usr/bin/env nake
# encoding: utf-8

begin
  require "nake/tasks/gem"
  require "nake/tasks/spec"
  require "nake/tasks/release"
rescue LoadError
  abort "You need nake gem!"
end

require_relative "lib/rango/version"

# ENV setup for external commands
ENV["RUBYLIB"] = Dir["gems/gems/*/lib"].join(":")
$LOAD_PATH.clear.push(*Dir["gems/gems/*/lib"])

# Setup encoding, so all the operations
# with strings from another files will work
Encoding.default_internal = "utf-8"
Encoding.default_external = "utf-8"

Task[:build].config[:gemspec] = "rango.gemspec"
Task[:prerelease].config[:gemspec] = "rango.pre.gemspec"
Task[:release].config[:name] = "rango"
Task[:release].config[:version] = Rango::VERSION

# http://github.com/somebee/rbench/tree/master
Task.new(:bm) do |task|
  task.description = "Run all benchmarks"
  task.define do
    abort "Benchmarks doesn't work at the moment"
    require "rbench"
    Dir["#{Dir.pwd}/benchmarks/bm/*.rb"].each do |benchmark|
      load benchmark
    end
  end
end
