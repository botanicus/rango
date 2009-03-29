# coding=utf-8

require "erubis"
Rango.import("templates/adapter")

class Rango::Template
  class Erubis < ::Rango::Template::Adapter
    def render(io, context)
      ::Erubis::Eruby.new(io.read).result(context, binding)
    end
  end
end
