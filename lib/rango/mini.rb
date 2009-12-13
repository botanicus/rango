# encoding: utf-8

require "rango/router"
require "rango/rack/request"

module Rango
  module Mini
    extend self # so you can run Rango::Mini.app
    def app(&block)
      raise ArgumentError, "Block is required" unless block_given?
      lambda do |env|
        Rango::Router.set_rack_env(env)
        request = Rango::Request.new(env)
        response = Rack::Response.new
        body = block.call(request, response)
        # TODO: check how rack test if object is stringable, probably not this way
        raise ArgumentError, "It has to return a valid rack body, #{body.inspect} returned" unless body.respond_to?(:each) || body.is_a?(String)
        response.write(body)
        array = response.finish
        [array[0], array[1], body] # we don't want to have Rack::Response instance instead body, it's mess!
      end
    end
  end
end
