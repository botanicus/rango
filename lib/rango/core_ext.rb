# encoding: utf-8

class String
  # Convert to snake case.
  #   "FooBar".snake_case           #=> "foo_bar"
  #   "HeadlineCNNNews".snake_case  #=> "headline_cnn_news"
  #   "CNN".snake_case              #=> "cnn"
  #
  # @return [String] Receiver converted to snake case.
  # @api public
  def snake_case
    return self.downcase if self =~ /^[A-Z]+$/
    self.gsub(/([A-Z]+)(?=[A-Z][a-z]?)|\B[A-Z]/, '_\&') =~ /_*(.*)/
      return $+.downcase
  end

  # Convert to camel case.
  #   "foo_bar".camel_case          #=> "FooBar"
  #
  # @return [String] Receiver converted to camel case.
  # @api public
  def camel_case
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    split('_').map{|e| e.capitalize}.join
  end

  # TODO: this certainly isn't the way to go,
  # but we need to get & refactor extlib at first
  def pluralize
    "#{self}s"
  end
end

class Hash
  # Return duplication of self with all keys non-recursively converted to symbols
  #
  # @author Botanicus
  # @since 0.0.2
  # @return [Hash] A hash with all keys transformed into symbols
  def symbolize_keys
    self.inject(Hash.new) do |result, array|
      result[array.first.to_sym] = array.last
      result
    end
  end
end

module ParamsMixin
  def self.switch_string_to_symbol_or_back(value)
    if value.is_a?(String)
      value.to_sym
    elsif value.is_a?(Symbol)
      value.to_s
    else
      value
    end
  end

  def self.convert(hash)
    hash.extend(ParamsMixin)
    hash.each do |key, value|
      self.convert(value) if value.is_a?(Hash)
    end
  end

  def [](key)
    if self.has_key?(key)
      super(key)
    elsif key2 = ParamsMixin.switch_string_to_symbol_or_back(key)
      super(key2)
    else # get the default value or run the default block
      super(key)
    end
  end

  def []=(key, value)
    if self.has_key?(key)
      super(key, value)
    elsif key2 = ParamsMixin.switch_string_to_symbol_or_back(key)
      super(key2, value)
    else # get the default value or run the default block
      super(key, value)
    end
  end

  # This might be very nasty if you expect a symbol,
  # but we can't just call #to_sym on it because of
  # security. Symbols aren't GCed, so if someone would
  # send a lot of requests with different keys, it will
  # crash your app or even server because it would run
  # out of memory.
  def keys
    super.map do |key|
      key.is_a?(Symbol) ? key.to_s : key
    end
  end

  def merge(*args)
    super(*args).extend(ParamsMixin)
  end

  def merge!(*args)
    super(*args).extend(ParamsMixin)
  end
end
