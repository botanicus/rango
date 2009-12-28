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

load "code-cleaner.nake"
Task["hooks:whitespace:install"].define do
  ARGV.clear.push(".git/hooks/pre-commit")
  ARGF.inplace_mode = ""
  while line = ARGF.gets
    puts %{export PATH="script:$PATH"} if ARGF.lineno.eql?(2)
    puts line
  end
end

unless File.exist?(".git/hooks/pre-commit")
  warn "If you want to contribute to Rango, please run ./tasks.rb hooks:whitespace:install to get Git pre-commit hook for removing trailing whitespace"
end

require_relative "lib/rango/version"

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
