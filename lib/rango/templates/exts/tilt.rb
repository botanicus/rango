# encoding: utf-8

require "tilt"

module Rango
  module TiltExtensions
    module Erubis
      def initialize_engine
        super
        require "rango/templates/exts/erubis"
      end
    end

    # Tilt::HamlTemplate.options[:default_attributes] = {script: {type: "text/javascript"}, form: {method: "POST"}}
    module Haml
      def self.included(klass)
        klass.send(:remove_method, :initialize_engine)
        def klass.options
          @options ||= Hash.new
        end
      end

      def initialize_engine
        require_template_library 'haml' unless defined? ::Haml::Engine
        require "rango/templates/exts/haml"
      end

      def initialize(*args)
        super
        self.options.merge!(self.class.options)
      end
    end
  end
end

Tilt::ErubisTemplate.send(:include, Rango::TiltExtensions::Erubis)
Tilt::HamlTemplate.send(:include, Rango::TiltExtensions::Haml)
