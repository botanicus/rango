# encoding: utf-8

module Rango
  def self.parse(args = ARGV)
    return if args.empty?
    # if you will run this script with -i argument, interactive session will begin
    Rango.interactive if ARGV.delete("-i")
    # so it can work as a runner
    load ARGV.shift if ARGV.first && File.exist?(ARGV.first) && ARGV.first.end_with?(".rb")
  end

  # Start IRB interactive session
  # @since 0.0.1
  def self.interactive
    require "irb"
    require "rango/utils"

    begin
      require "racksh/boot"
    rescue LoadError
      Rango.logger.info("For more goodies install racksh gem")
    else
      Rango::Utils.load_rackup # so you can use Rango::Router.app etc
    end

    begin
      require "irb/completion"
    rescue LoadError
      # some people can have ruby compliled without readline
    end

    ARGV.delete("-i") # otherwise irb will read it
    IRB.start
  end
end
