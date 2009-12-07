# encoding: utf-8

require "rango/gv"
require "rango/mini"
require "rango/mixins/render"

module Rango
  extend Rango::RenderMixin
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
