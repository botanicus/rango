# coding=utf-8

require "erb"
Rango.import("templates/adapter")

class Rango
  module Templates
    class Erb < ::Rango::Templates::Adapter
      # @since 0.0.2
      def render(io, context)
        ::ERB.new(io.read).result(context.binding)
      end
    end
  end
end
