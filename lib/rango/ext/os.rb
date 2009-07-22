# encoding: utf-8

class OS < BasicObject
  class << self
    KEYS = ENV.keys.select { |key, value| key.match(/^[A-Z][A-Z_]*$/) }
    KEYS.each do |key|
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
end
