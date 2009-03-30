# coding=utf-8

class Rango
  module Templates
    class << self
      def engine(name)
        Rango::Templates.const_get(name.capitalize)
      end
    end

    class Adapter
      def proceed(io)
        raise "This must be redefined in subclasses!"
      end
    end
  end
end
