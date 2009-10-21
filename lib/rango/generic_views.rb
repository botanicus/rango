# encoding: utf-8

Rango.import("mixins/mini")

# what about filters?
#   - include to controller or use directly
module Rango
  module GenericViews
    def self.dispatcher(action)
      lambda do |env|
        Rango.logger.debug("Dispatching to #{self.class}##{action}")
        self.send(action, env)
      end
    end

    include Rango::Mini
    extend self # so we can dispatch directly
    # require params[:path]
    # @example
    #   Rango::Router.use(:usher)
    #   Project.router = Usher::Interface.for(:rack) do
    #     get("/:template").to(::Static.dispatcher(:show)).name(:static)
    #     get("/:template").to(Rango::GenericViews.dispatcher(:static)).name(:static)
    #     get("/:template").to do |env|
    #       env["rango.params"][:template] # transform
    #       Rango::GV.static
    #     end
    #   end
    def static
      app do |request, response|
        template = "#{request.script_name[1..-1]}.html"
        Rango.logger.debug("Rendering '#{template}'")
        render template
      end
    end
  end
end

Rack::Builder.send(:include, Rango::GenericViews)
