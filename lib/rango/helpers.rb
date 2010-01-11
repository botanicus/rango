# encoding: utf-8

module Rango
  module Helpers
    # tag :a, href: "/contact" { anchor }
    # tag :a, "contact", href: "/contact"
    # @since 0.0.2
    def tag(tag, content, attrs = Hash.new, &block)
      attrs, content = content, String.new if attrs.empty? && content.is_a?(Hash)
      block.call if block
      %[<#{tag}#{attrs_to_html(attrs)}>#{content}</#{tag}>]
    end

    # @since 0.0.2
    def single_tag(tag, attrs = Hash.new)
      %[<#{tag}#{attrs_to_html(attrs)} />]
    end

    private
    def attrs_to_html(attrs)
      attrs.inject(String.new) do |result, pair|
        key, value = pair
        result += " #{key}='#{value}'"
      end
    end
  end
end

require "rango/helpers/assets"
require "rango/helpers/syntax"
require "rango/helpers/general"
