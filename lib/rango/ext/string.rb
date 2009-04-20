# coding: utf-8

try_require "term/ansicolor", "term-ansicolor"

class String
  # @since 0.0.1
  # @example
  #   "message".colorize.red.colorize.bold
  # @param [type] name explanation
  # @return [String] Return duplication of self. In it's metaclass is included +Term::ANSIColor+.
  def colorize
    return self unless defined?(Term)
    message = self.dup # otherwise it can try to modify frozen string
    class << message
      include Term::ANSIColor
    end
    return message
  end

  # rack
  # @since 0.0.2
  alias_method :each, :each_line
end