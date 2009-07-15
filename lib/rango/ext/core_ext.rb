# encoding: utf-8

# TODO: spec it
class Hash
  # @since 0.0.2
  def to_html_attrs
    self.map { |key, value| "#{key}='#{value}'" }.join(" ")
  end

  def symbolize_keys
    self.inject(Hash.new) do |result, array|
      result[array.first.to_sym] = array.last
      result
    end
  end

  def symbolize_keys!
    self.replace(self.symbolize_keys)
  end

  def deep_symbolize_keys
    self.inject(Hash.new) do |result, array|
      key, value = array.first, array.last
      if value.respond_to?(:symbolize_keys)
        result[key.to_sym] = value.symbolize_keys
      else
        result[key.to_sym] = value
      end
      result
    end
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
