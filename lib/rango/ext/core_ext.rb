# coding=utf-8

# TODO: spec it
require File.join(File.dirname(__FILE__), "path")

class Hash
  # @since 0.0.2
  def to_html_attrs
    self.map { |key, value| "#{key}='#{value}'" }.join(" ")
  end
end

require "rango/ext/kernel"
require "rango/ext/string"
require "rango/ext/class"