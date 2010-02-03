# encoding: utf-8

require "tilt"
require "rango/mixins/chainable"

module Tilt
  ErubisTemplate.class_eval do
    extend Chainable
    chainable do
      def initialize_engine
        super
        require "rango/templates/exts/erubis"
      end
    end
  end

  # Tilt::HamlTemplate.options[:default_attributes] = {script: {type: "text/javascript"}, form: {method: "POST"}}
  HamlTemplate.class_eval do
    extend Chainable

    def self.options
      @options ||= Hash.new
    end

    chainable do
      def initialize_engine
        super
        require "rango/templates/exts/haml"
      end

      def haml_options
        super.merge!(self.class.options)
      end
    end
  end
end
