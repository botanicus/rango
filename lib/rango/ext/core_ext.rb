# coding=utf-8

# TODO: spec it
require File.join(File.dirname(__FILE__), "path")

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
end

require "rango/ext/kernel"
require "rango/ext/string"
require "rango/ext/class"