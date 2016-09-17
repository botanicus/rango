# encoding: utf-8

require "rango/gv"
require "rango/mini"
require "rango/mixins/render"

module Rango
  module GV
    # The problem is that if you have an Application class with some shared functionality like error handling (rendering 500.html etc), then this won't work with it.
    def self.static(template, scope = Object.new, context = Hash.new, &hook)
      Rango::Mini.app do |request, response|
        path = template || request.env["rango.router.params"][:template]
        path = hook.call(path) unless hook.nil?
        path = "#{path}.html" unless path.match(/\./)
        Rango.logger.debug("Rendering '#{path}'")
        # Rango::RenderMixin.scope
        context = context.call(request) if context.respond_to?(:call) # lambda { |request| {msg: request.message} }
        Rango::RenderMixin.render path, scope, context
      end
    end

    # you would usually define module Static with instance method static for
    # including into controllers, but since controllers have render, it would be useless
  end
end
