# encoding: utf-8

class Rango
  module Templates
    class << self
      # @since 0.0.2
      def engine(name)
        Rango::Templates.const_get(name.capitalize)
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
