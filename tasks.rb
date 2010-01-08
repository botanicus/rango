#!./script/nake
# encoding: utf-8

begin
  require_relative "gems/environment.rb"
rescue LoadError
  abort "You have to install bundler and run gem bundle first!"
end

ENV["PATH"] = "script:#{ENV["PATH"]}"

require "nake/tasks/gem"
require "nake/tasks/spec"
require "nake/tasks/release"

begin
  load "code-cleaner.nake"
  Nake::Task["hooks:whitespace:install"].tap do |task|
    task.config[:path] = "script"
    task.config[:encoding] = "utf-8"
    task.config[:whitelist] = '(bin/[^/]+|Gemfile|.+\.(rb|rake|nake|thor|task|gemspec|rbt))$'
  end
rescue LoadError
  warn "If you want to contribute to Rango, please install code-cleaner and then run ./tasks.rb hooks:whitespace:install to get Git pre-commit hook for removing trailing whitespace."
end

require_relative "lib/rango"

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
