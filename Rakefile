# encoding: utf-8

require_relative "lib/rango/version"

# ENV setup for external commands
ENV["RUBYLIB"] = Dir["gems/gems/*/lib"].join(":")
$LOAD_PATH.clear.push(*Dir["gems/gems/*/lib"])

# encoding
Encoding.default_internal = "utf-8"
Encoding.default_external = "utf-8"

# http://support.runcoderun.com/faqs/builds/how-do-i-run-rake-with-trace-enabled
Rake.application.options.trace = true

task :bundle do
  # NOTE: the sense of the checkout is to avoid overwriting our changes in scripts
  exec "gem bundle --cached && git checkout script"
end

# default task for RunCodeRun.com
task :default => [:bundle, :spec]

# load tasks
Dir["tasks/*.rake"].each do |taskfile|
  begin
    load File.join(Dir.pwd, taskfile)
  rescue Exception => exception
    puts "Exception #{exception.class} occured during loading #{taskfile}:"
    puts exception.message
    puts exception.backtrace
  end
end
