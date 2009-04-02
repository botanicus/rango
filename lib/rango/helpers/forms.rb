# coding=utf-8

class Rango
  module Helpers
    # @since 0.0.2
    def field(type, default, options = Hash.new)
      attrs = {type: type, value: default}
      attrs = attrs.merge(options)
      single_tag :input, attrs
    end
    
    # @since 0.0.2
    def submit(title = "submit")
      field "submit", title, title: title
    end
    
    def form(url, &block)
      tag :from, action: url, method: "post", &block
    end
  end
end