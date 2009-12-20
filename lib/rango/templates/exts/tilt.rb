# encoding: utf-8

require "tilt"
require "rango/mixins/chainable"

module Tilt
  ErubisTemplate.class_eval do
    extend RubyExts::Chainable
    chainable do
      def initialize_engine
        super
        require "rango/templates/exts/erubis"
      end
    end
  end

  HamlTemplate.class_eval do
    extend RubyExts::Chainable
    chainable do
      def initialize_engine
        super
        require "rango/templates/exts/haml"
      end
    end
  end
end
