# encoding: utf-8

require "irb"
require "rango/utils"
require "rubyexts"

# Start IRB interactive session
# @since 0.0.1
def Rango.interactive
  ARGV.delete("-i") # otherwise irb will read it
  ENV["RACK_ENV"] = Rango.environment # for racksh
  unless try_require("racksh/boot")
    Rango.logger.info("For more goodies install racksh gem")
    try_require "irb/completion" # some people can have ruby compliled without readline
    Rango::Utils.load_rackup # so you can use Project.router etc
  end
  IRB.start
end
