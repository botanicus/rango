# encoding: utf-8

require "rango" # logger
require "rango/template"

module Rango
  module RenderMixin
    extend self # so you can use Rango::RenderMixin.render

    # @since 0.0.2
    def render(path, scope = Object.new, context = Hash.new)
      scope, context = Object.new, scope if context.empty? && scope.is_a?(Hash)
      #Rango.logger.inspect(context: context)
      template = TemplateInheritance::Template.new(path, scope)
      return template.render(context)
    end
  end
end
