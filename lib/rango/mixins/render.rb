# encoding: utf-8

require "rango" # logger
require "rango/templates/template"

module Rango
  module RenderMixin
    extend self # so you can use Rango::RenderMixin.render

    # @since 0.0.2
    def render(path, context = Object.new, locals = Hash.new)
      context, locals = Object.new, context if locals.empty? && context.is_a?(Hash)
      Rango.logger.inspect(locals: locals)
      template = Rango::Templates::Template.new(path, context)
      return template.render(locals)
    end
  end
end
