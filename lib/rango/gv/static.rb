# encoding: utf-8

# Generic Views
# Use directly or include into a controller if you want to use filters or customize them
# http://wiki.github.com/botanicus/rango/generic-views

require "rango/gv"

module Rango
  module GV
    def self.static(template, locals = nil, &hook)
      Rango::Mini.app do |request, response|
        path = template || request.env["rango.router.params"][:template]
        path = hook.call(path) unless hook.nil?
        path = "#{path}.html" unless path.match(/\./)
        Rango.logger.debug("Rendering '#{path}'")
        # Rango::RenderMixin.context
        locals = locals.call(request) if locals.respond_to?(:call) # lambda { |request| {msg: request.message} }
        render path, locals
      end
    end

    # you would usually define module Static with instance method static for
    # including into controllers, but since controllers have render, it would be useless
  end
end
