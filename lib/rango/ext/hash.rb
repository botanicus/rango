# encoding: utf-8

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

  def to_url_attrs
    self.map { |key, value| "#{key}=#{value}" }.join("&")
  end

  def reverse_merge(another)
    another.merge(self)
  end

  def reverse_merge!(another)
    self.replace(self.reverse_merge(another))
  end

  # @deprecated
  def to_native
    self.each do |key, value|
      value = case value
      when "true" then true
      when "false" then false
      when "nil" then nil
      when /^\d+$/ then value.to_i
      when /^\d+\.\d+$/ then value.to_f
      else value end
      self[key.to_sym] = value
    end
    return self
  end

  # Simplier syntax for code such as params[:post] && params[:post][:title]
  # 
  # @author Jakub Stastny aka Botanicus
  # @param [Object] First argument is the key of the hash, the second one the key of the inner hash selected by the first key etc.
  # @return [Object, nil] The value of the most inner hash if found or nil.
  # @raise [ArgumentError] If you don't specify keys.
  # 
  # @example
  #   {a: {b: 1}}.get(:a, :b)     # => 1
  #   {a: {b: 1}}.get(:a, :b, :c) # => IndexError
  #   {a: {b: 1}}.get(:a, :c)     # => nil
  def get(*keys)
    raise ArgumentError, "You must specify at least one key" if keys.empty?
    keys.inject(self) do |object, key|
      # Hash#fetch works similar as Hash#[], but [] method is
      # defined for too many objects, also strings and even numbers
      if object.respond_to?(:fetch)
        begin
          object.fetch(key)
        # Hash#fetch raise IndexError if key doesn't exist
        rescue IndexError
          return nil
        end
      else
        raise IndexError, "Object #{object.inspect} isn't hash-like collection"
      end
    end
  end
end
