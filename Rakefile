# encoding: utf-8

# http://support.runcoderun.com/faqs/builds/how-do-i-run-rake-with-trace-enabled
Rake.application.options.trace = true

# default task for RunCodeRun.com
task :default => ["submodules:init", :spec]

# load tasks
Dir["tasks/*.rake"].each do |taskfile|
  load taskfile
end
