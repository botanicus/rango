# coding: utf-8

require "delegate"
require "extlib"
require_relative "string"
require_relative "attribute"

class ColoredString
  ATTRIBUTES = {
    clear: 0,
    reset: 0,     # synonym for :clear
    bold: 1,
    dark: 2,
    italic: 3,     # not widely implemented
    underline: 4, 
    underscore: 4,     # synonym for :underline
    blink: 5, 
    rapid_blink: 6,     # not widely implemented
    negative: 7,     # no reverse because of String#reverse
    concealed: 8, 
    strikethrough: 9,     # not widely implemented
    black: 30, 
    red: 31, 
    green: 32, 
    yellow: 33, 
    blue: 34, 
    magenta: 35, 
    cyan: 36, 
    white: 37, 
    on_black: 40, 
    on_red: 41, 
    on_green: 42, 
    on_yellow: 43, 
    on_blue: 44, 
    on_magenta: 45, 
    on_cyan: 46, 
    on_white: 47, 
  }

  class << self
    # ColoredString.coloring?
    # Returns true, if the coloring function of this module
    # is switched on, false otherwise.
    # 
    # ColoredString.coloring = boolean
    # Turns the coloring on or off globally, so you can easily do
    # this for example:
    #  Term::ANSIColor::coloring = STDOUT.isatty
    questionable :coloring, true
  end
  
  attr_accessor :colors
  def initialize(string = "")
    @string = string
    @colors = Array.new
  end

  ATTRIBUTES.each do |color, code|
    define_method(color) do
      @colors.push(color)
      self
    end
  end
  
  def to_s
    if ! @colors.empty? && self.class.coloring?
      sequences = ""
      @colors.each do |name|
        code = ATTRIBUTES[name]
        sequences << "\e[#{code}m"
      end
      return "#{sequences}#{@string}\e[0m"
    else
      @string
    end
  end
  
  def inspect
    "#<ColoredString:#@string>"
  end
  
  def raw
    @string
  end
  
  def method_missing(method, *args, &block)
    returned = @string.send(method, *args, &block)
    # Bang methods like upcase!
    if returned.is_a?(String) and @string.equal?(returned) # same object
      @string.replace(returned)
      return self
    # upcase
    elsif returned.is_a?(String) and not @string.equal?(returned) # different object
      return self.class.new(returned)
    else # not string, String#split etc
      return returned
    end
  end
end
