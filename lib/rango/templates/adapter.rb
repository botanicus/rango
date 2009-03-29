# coding=utf-8

class Rango::Template
  class << self
    def engine(name)
      Rango::Template.const_get(name.capitalize)
    end
  end

  class Adapter
    def proceed(io)
      raise "This must be redefined in subclasses!"
    end
  end
end
