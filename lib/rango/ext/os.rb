# encoding: utf-8

require "blankslate"

class OS < BlankSlate
  def initialize(env = ENV)
    keys(env).each do |key|
      if key.match(/(PATH|LIB)$/)
        # OS.path
        # => ["/bin", "/usr/bin", "/sbin", "/usr/sbin"]
        define_method(key.downcase) { ENV[key].split(":") }
      else
        # OS.home
        # => "/Users/botanicus"
        define_method(key.downcase) { ENV[key] }
      end
    end
  end

  def keys(env = ENV)
    @@keys ||= env.keys.select { |key, value| key.match(/^[A-Z][A-Z_]*$/) }
  end

  def root?
    ENV["UID"].is?(0)
  end
end
