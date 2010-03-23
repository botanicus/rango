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
    # @deprecated
    def load_rackup(path = "config.ru")
      app, options = Rack::Builder.parse_file(path)
      return app
    end
  end
end
