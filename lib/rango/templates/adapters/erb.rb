# coding=utf-8

require "erb"
Rango.import("templates/adapter")

class Rango
  module Templates
    class Erb < ::Rango::Templates::Adapter
      def render(io, context)
        ::ERB.new(io.read).result(context.binding)
      end
    end
  end
end
