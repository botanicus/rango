# encoding: utf-8

class Hash
  def to_url_attrs
    self.map { |key, value| "#{key}=#{value}" }.join("&")
  end

  def reverse_merge(another)
    another.merge(self)
  end

  def reverse_merge!(another)
    self.replace(self.reverse_merge(another))
  end

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
end
