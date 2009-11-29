# encoding: utf-8

require "rack"

module Rango
  module Utils
    def self.load_rackup(path = "config.ru")
      eval("Rack::Builder.new {( #{File.read(path)}\n )}.to_app", nil, File.expand_path(path))
    end
  end
end