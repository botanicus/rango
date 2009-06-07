# encoding: utf-8

module Rack
  class Builder
    def app(&block)
      lambda do |env|
        request = Rango::Request.new(env)
        response = Rack::Response.new
        body = block.call(request, response)
        # TODO: check how rack test if object is stringable, probably not this way
        raise ArgumentError unless body.respond_to?(:each) || body.is_a?(String)
        response.write(body)
        response.finish
      end
    end
    
    def render(template, locals = Hash.new)
      Rango.import("templates/template")
      Rango::Templates::Template.new(template, self, locals).render
    end
  end
end