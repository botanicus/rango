# encoding: utf-8

require "haml"
Rango.import("templates/adapter")

class Rango
  module Templates
    class Haml < ::Rango::Templates::Adapter
      # @since 0.0.2
      def render(io, scope, locals = Hash.new)
        options = Project.settings.haml.to_hash ### FIXME
        options[:filename] = io.path
        ::Haml::Engine.new(io.read, options).render(scope, locals)
      end
    end
  end
end
