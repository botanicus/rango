# coding=utf-8

class Rango
  module Helpers
    def textile(text)
      require "redcloth"
    end
    
    def markdown(text)
      require "bluecloth"
    end
    
    def maruku(text, options = Hash.new)
      require "maruku"
    end
    
    def syntax(text, options = Hash.new)
      require "syntax/convertors/html"
      convertor = Syntax::Convertors::HTML.for_syntax(options[:language] || "ruby")
      convertor.convert(text, false)
    end
  end
end