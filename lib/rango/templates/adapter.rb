# encoding: utf-8

module Rango
  module Templates
    class << self
      # @since 0.0.2
      def engine(name)
        Rango::Templates.const_get(name.to_s.capitalize + "Adapter")
      end
    end

    class Adapter
      # @since 0.0.2
      def proceed(io)
        raise "This must be redefined in subclasses!"
      end
    end
  end
end
