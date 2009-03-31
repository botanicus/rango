# coding=utf-8

class Rango
  module Helpers
    # tag :a, href: "/contact" { anchor }
    # tag :a, "contact", href: "/contact"
    # @since 0.0.2
    def tag(tag, content, attrs = Hash.new)
      attrs, content = content, String.new if attrs.empty? && content.is_a?(Hash)
      %[<#{tag} #{attrs.to_html_attrs}>#{content}</#{tag}>]
    end
    
    # @since 0.0.2
    def single_tag(tag, attrs = Hash.new)
      %[<#{tag} #{attrs.to_html_attrs} />]
    end
  end
end

Rango.import("mvc/helpers/assets")
Rango.import("mvc/helpers/forms")
Rango.import("mvc/helpers/syntax")
Rango.import("mvc/helpers/general")