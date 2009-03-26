class Rango::Template
  class Adapter
    def proceed(io)
      raise "This must be redefined in subclasses!"
    end
  end
end
