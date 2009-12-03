# encoding: utf-8

require "rango/project"
require "rango/router"
require "rango/templates/template"

# This mixin should be included to the all objects which are supposed to return response for Rack, so not just ControllerStrategy, but also CallableStrategy
module Rango
  module RenderMixin
    include Rango::UrlHelper
    extend self # so you can use Rango::RenderMixin.render

    # class Posts < Rango::Controller
    #   def context
    #     Object.new
    #   end
    #
    #   def show
    #     # you can't use @explicit
    #     post = Post.get(params[:id])
    #     render "post.html", post: post
    #   end
    # end
    #
    # Context for rendering templates
    # This context will be extended by same crucial methods from template mixin
    # We are in context of current controller by default
    def context
      Object.new.extend(Rango::Helpers)
    end

    # def show
    #   locals[:post] = Post.get(params[:id])
    #   render "show.html", locals
    # end
    def locals
      @locals ||= {message: self.message}
    end

    # TODO: extensions handling
    # @since 0.0.2
    def render(template, locals = Hash.new)
      Rango.logger.inspect(locals: locals.merge(request: self.request.to_s))
      locals = {request: self.request}.merge(locals)
      if self.class.respond_to?(:before_render_filters) # generic views, plain rack etc
        run_filters2 self.class.before_render_filters, template, locals
      end
      template, locals = self.template_location, template if template.is_a?(Hash) && locals.empty?
      template2 = Rango::Templates::Template.new(template, self.context)
      if self.class.respond_to?(:after_render_filters)
        run_filters2 self.class.after_render_filters, template2
      end
      return template2.render(locals)
    end

    # @since 0.0.2
    def display(object, template, locals = Hash.new)
      if self.class.respond_to?(:before_display_filters)
        run_filters2 self.class.before_display_filters, object, template, locals
      end
      result = render(template)
      if self.class.respond_to?(:after_display_filters)
        run_filters2 self.class.after_display_filters, object, result
      end
      return result
    rescue Error406
      # TODO: provides API
      format = Project.settings.mime_formats.find do |format|
        object.respond_to?("to_#{format}")
      end
      format ? object.send("to_#{format}") : raise(Error406.new(self.params))
    end

    def run_filters2(array, *args)
      array.each do |filter|
        Rango.logger.debug("Calling filter #{filter.inspect}")
        filter.call(*args)
      end
    end
  end
end
