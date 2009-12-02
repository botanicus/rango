# encoding: utf-8

require "tilt"
require "rubyexts/mixins/chainable"

module Tilt
  ErubisTemplate.class_eval do
    extend RubyExts::Chainable
    chainable do
      def initialize_engine
        super
        require "rango/templates/erubis"
      end
    end
  end
end