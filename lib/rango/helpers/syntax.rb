# coding: utf-8

class Rango
  module Helpers
    # @since 0.0.1
    def textile(text)
      require "redcloth"
      RedCloth.new(text).to_html
    end

    # @since 0.0.1
    def markdown(text)
      require "bluecloth"
    end

    # @since 0.0.1
    def maruku(text, options = Hash.new)
      require "maruku"
    end

    # @since 0.0.1
    def syntax(text, options = Hash.new)
      require "syntax/convertors/html"
      convertor = Syntax::Convertors::HTML.for_syntax(options[:language] || "ruby")
      convertor.convert(text, false)
    end
  end
end
