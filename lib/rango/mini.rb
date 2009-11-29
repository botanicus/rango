# encoding: utf-8

# Rango::Mini is the most low-level part which can render
# templates standalone. More low-level is only the RenderMixin.
# See http://wiki.github.com/botanicus/rango/template-rendering

require "rango/mixins/render"
require "rango/rack/request"

module Rango
  module Mini
    include Rango::RenderMixin
    extend self # so you can run Rango::Mini.app
    def app(&block)
      raise ArgumentError, "Block is required" unless block_given?
      lambda do |env|
        request = Rango::Request.new(env)
        response = Rack::Response.new
        body = block.call(request, response)
        # TODO: check how rack test if object is stringable, probably not this way
        raise ArgumentError unless body.respond_to?(:each) || body.is_a?(String)
        response.write(body)
        array = response.finish
        [array[0], array[1], body] # we don't want to have Rack::Response instance instead body, it's mess!
      end
    end
  end
end
