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

  # Transform self to +ColoredString+
  # @since 0.0.1
  # @example
  #   "message".colorize.red.bold
  # @param [type] name explanation
  # @return [String] Transfrom self to +ColoredString+
  def colorize
    require_relative "colored_string"
    ColoredString.new(self)
  end

  # For Rack
  # @since 0.0.2
  # @todo Is it still required?
  alias_method :each, :each_line
end
