# encoding: utf-8

# Features:
#   - autoescaping
#   - caching (not yet)

require "haml"
require "rango/templates/adapter"

module Rango
  module Templates
    class HamlAdapter < Adapter
      # @since 0.0.2
      def render(io, scope, locals = Hash.new)
        options = Project.settings.haml.to_hash ### FIXME
        options[:filename] = io.path
        if File.exist?("#{io.path}.cache")
          eval(File.read("#{io.path}.cache"), scope)
        else
          engine = Haml::Engine.new(io.read, options)
          engine.render(scope, locals)
        end
      end
    end
  end
end
