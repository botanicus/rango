# encoding: utf-8

task :setup => ["setup:submodules"]

namespace :setup do
  task :submodules do
    unless File.directory?("vendor")
      sh "git submodule init"
    end
  end
end

task :default => :setup do
  rubylib = (ENV["RUBYLIB"] || String.new).split(":")
  libdirs = Dir["vendor/*/lib"]
  ENV["RUBYLIB"] = (libdirs + rubylib).join(":")
  exec "spec --options spec/spec.opts spec"
end
