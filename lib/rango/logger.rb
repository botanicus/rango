# encoding: utf-8

require "rango"
require_gem "rubyexts", "rubyexts/logger"

# @since 0.0.1
# @example
#   Rango.root
#   # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
# @return [RubyExts::Logger] Logger for logging framework-related stuff. For logging project-relating stuff please use Project.logger.
# @see Project::logger
def Rango.logger
  @logger ||= RubyExts::Logger.new
end
