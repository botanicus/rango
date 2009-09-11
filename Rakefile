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
  libdirs = Dir["vendor/*/lib"]
  ENV["RUBYLIB"] = libdirs.join(":") + ENV["RUBYLIB"]
  exec "spec --options spec/spec.opts spec"
end
