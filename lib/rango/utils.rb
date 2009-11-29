# encoding: utf-8

require "rack"

# class App
#   extend Rango::Utils
#   def load_rackup
#     super(File.join(File.join(self.root, "config.ru")), "config.ru")
#   end
# end
module Rango
  module Utils
    extend self
    def load_rackup(path = "config.ru")
      eval("Rack::Builder.new {( #{File.read(path)}\n )}.to_app", nil, File.expand_path(path))
    end
  end
end