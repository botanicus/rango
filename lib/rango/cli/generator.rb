# coding: utf-8

class Rango
  class Generator
    def initialize(argv)
      type = argv.shift
      Rango.import("cli/#{type}")
      constant = Rango.const_get(type.camel_case)
      constant.new(argv).create
    rescue ArgumentError => exception
      raise exception
      # TODO: message
    end
  end
end
