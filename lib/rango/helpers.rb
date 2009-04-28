# coding: utf-8

class Rango
  module Helpers
    # tag :a, href: "/contact" { anchor }
    # tag :a, "contact", href: "/contact"
    # @since 0.0.2
    def tag(tag, content, attrs = Hash.new, &block)
      attrs, content = content, String.new if attrs.empty? && content.is_a?(Hash)
      block.call if block
      %[<#{tag} #{attrs.to_html_attrs}>#{content}</#{tag}>]
    end

    # @since 0.0.2
    def single_tag(tag, attrs = Hash.new)
      %[<#{tag} #{attrs.to_html_attrs} />]
    end
  end
end

Rango.import("helpers/assets")
Rango.import("helpers/syntax")
Rango.import("helpers/general")
Rango.import("helpers/merb-helpers")
