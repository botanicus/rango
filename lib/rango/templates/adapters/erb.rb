# coding=utf-8

require "erb"
Rango.import("templates/adapter")

class Rango::Template
  class Erb < ::Rango::Template::Adapter
    def render(io, context)
      ::ERB.new(io.read).result(context.binding)
    end
  end
end
