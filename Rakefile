# encoding: utf-8

# http://support.runcoderun.com/faqs/builds/how-do-i-run-rake-with-trace-enabled
Rake.application.options.trace = true

# default task for RunCodeRun.com
task :default do
  exec "gem bundle --cached && git checkout script && ./script/nake tasks.rb spec"
end
