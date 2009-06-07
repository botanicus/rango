# encoding: utf-8

# TODO: spec it
class Hash
  # @since 0.0.2
  def to_html_attrs
    self.map { |key, value| "#{key}='#{value}'" }.join(" ")
  end

  def symbolize_keys
    output = Hash.new
    self.each do |key, value|
      output[key.to_sym] = value
    end
    return output
  end

  def symbolize_keys!
    self.replace(self.symbolize_keys)
  end

  def deep_symbolize_keys
    output = Hash.new
    self.each do |key, value|
      if value.is_a?(Hash)
        output[key.to_sym] = value.symbolize_keys
      else
        output[key.to_sym] = value
      end
    end
    return output
  end

  def deep_symbolize_keys!
    self.replace(self.deep_symbolize_keys)
  end

  # Returns the value of self for each argument and deletes those entries.
  #
  # ==== Parameters
  # *args:: the keys whose values should be extracted and deleted.
  #
  # ==== Returns
  # Array[Object]:: The values of the provided arguments in corresponding order.
  #
  # :api: public
  def extract!(*args)
    args.map do |arg|
      self.delete(arg)
    end
  end
end
