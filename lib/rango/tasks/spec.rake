# encoding: utf-8

desc "Run specs"
task :spec, :path do |task, args|
  path = args.path ? "spec" : args.path
  sh "./bin/spec --options spec/spec.opts #{path}"
end
