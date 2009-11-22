# encoding: utf-8

module Rango
  module Testing
    extend self
    def load_rackup(path = "config.ru")
      fullpath = File.join(Project.root, "config.ru")
      Rango.logger.debug("Parsing #{fullpath}")
      rackup = File.read(fullpath)
      eval("Rack::Builder.new {( #{rackup}\n )}.to_app", nil, fullpath)
    end
  end
end