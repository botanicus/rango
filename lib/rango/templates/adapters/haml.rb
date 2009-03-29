# coding=utf-8

require "haml"
Rango.import("templates/adapter")

class Rango::Template
  class Haml < ::Rango::Template::Adapter
    def render(io, scope)
      ::Haml::Engine.new(io.read).render(scope)
    end
  end
end
