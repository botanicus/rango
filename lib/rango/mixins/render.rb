# encoding: utf-8

require "rango/router"
require "rango/templates/template"

# This mixin should be included to the all objects which are supposed to return response for Rack, so not just ControllerStrategy, but also CallableStrategy
module Rango
  module RenderMixin
    include Rango::UrlHelper

    # @since 0.0.1
    # @return [Rango::Request]
    # @see Rango::Request
    attr_accessor :request, :params, :cookies, :response
    # @since 0.0.1
    # @return [Hash] Hash with params from request. For example <code>{messages: {success: "You're logged in"}, post: {id: 2}}</code>
    attr_accessor :params

    attribute :status
    attribute :headers, Hash.new

    # @since 0.0.1
    # @return [Rango::Logger] Logger for logging project related stuff.
    # @see Rango::Logger
    attribute :logger, Project.logger

    # The rails-style flash messages
    # @since 0.0.2
    def message
      @message ||= (request.GET[:msg] || Hash.new)
    end

    # @since 0.0.2
    def redirect(url, options = Hash.new)
      self.status = 302

      # for example ?msg[error]=foo
      [:error, :success, :notice].each do |type|
        if msg = (options[type] || message[type])
          url.concat("?msg[#{type}]=#{msg}")
        end
      end

      self.headers["Location"] = URI.escape(url)
      return String.new
    end

    # Calls the capture method for the selected template engine.
    #
    # ==== Parameters
    # *args:: Arguments to pass to the block.
    # &block:: The block to call.
    #
    # ==== Returns
    # String:: The output of a template block or the return value of a non-template block converted to a string.
    #
    # :api: public
    def capture(*args, &block)
      ret = nil

      captured = send("capture_#{Project.settings.template_engine}", *args) do |*args|
        ret = yield *args
      end

      # return captured value only if it is not empty
      captured.empty? ? ret.to_s : captured
    end
    
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
      self
    end

    # Calls the concatenate method for the selected template engine.
    #
    # ==== Parameters
    # str<String>:: The string to concatenate to the buffer.
    # binding<Binding>:: The binding to use for the buffer.
    #
    # :api: public
    def concat(str, binding)
      self.send("concat_#{Project.settings.template_engine}", str, binding)
    end

    # view:
    # render "index"
    # template:
    # extends "base.html" if layout
    # This is helper can works as render layout: false for AJAX requests when you probably would like to render just the page without layout
    def layout
      request.ajax?
    end

    # RENDERING #
    def template_location(extension = "html")
      File.join(self.controller_name, "#{self.env[:action]}.#{extension}")
    end

    # TODO: extensions handling
    # @since 0.0.2
    def render(template, locals = Hash.new)
      if self.class.respond_to?(:before_render_filters) # generic views, plain rack etc
        run_filters2 self.class.before_render_filters, template, locals
      end
      template, locals = self.template_location, template if template.is_a?(Hash) && locals.empty?
      template2 = Rango::Templates::Template.new(template, self.context, locals)
      if self.class.respond_to?(:after_render_filters)
        run_filters2 self.class.after_render_filters, template2
      end
      return template2.render
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
