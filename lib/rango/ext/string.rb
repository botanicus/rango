# encoding: utf-8

class String
  # Transform self into titlecased string.
  #
  # @author Botanicus
  # @since 0.0.3
  # @return [String] Titlecased string
  # @examples
  #   "hello world!".titlecase # => "Hello World!"
  def titlecase
    self.gsub(/\b./) { $&.upcase }
  end

  # @since 0.0.1
  # @example
  #   "message".colorize.red.bold
  # @param [type] name explanation
  # @return [String] Return duplication of self. In it's metaclass is included +Term::ANSIColor+.
  def colorize
    ColoredString.new(self)
  end

  # rack
  # @since 0.0.2
  alias_method :each, :each_line
end
