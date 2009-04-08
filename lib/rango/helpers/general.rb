# coding=utf-8

class Rango
  module Helpers
    # @since 0.0.1
    def copyright(from)
      now = Time.now.year
      now.eql?(from) ? now : "#{from} - #{now}"
    end

    # @since 0.0.2
    def link_to(name, url, options = Hash.new)
      default = {href: url, title: name}
      tag :a, name, default.merge(options)
    end

    # @since 0.0.2
    def link_item(name, url)
      tag :li, link_to(name, url)
    end
  end
end