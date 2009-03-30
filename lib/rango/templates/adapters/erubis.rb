# coding=utf-8

require "erubis"
Rango.import("templates/adapter")

class Rango
  module Templates
    class Erubis < ::Rango::Templates::Adapter
      def render(io, context)
        ::Erubis::Eruby.new(io.read).result(context, binding)
      end
    end
  end
end
