# coding: utf-8

Rango.import("mixins/controller")

# run app { |request, response|
# if request.env["PATH_INFO"].match(/^\/admin/)
#   redirect ""
# else
#   render "index"
# end
# }
class Rango
  module Mini
    include Rango::ControllerMixin
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
  end
end

Rack::Builder.send(:include, Rango::Mini)
