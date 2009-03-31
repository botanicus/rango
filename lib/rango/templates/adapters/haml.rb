# coding=utf-8

require "haml"
Rango.import("templates/adapter")

class Rango
  module Templates
    class Haml < ::Rango::Templates::Adapter
      def render(io, scope, locals = Hash.new)
        ::Haml::Engine.new(io.read, :filename => io.path).render(scope, locals)
      end
    end
  end
end
