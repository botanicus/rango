# encoding: utf-8

Rango.import("mixins/mini")

class Rango
  module GenericViews
    include Rango::Mini
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
