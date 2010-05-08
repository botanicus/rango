# encoding: utf-8

require "rango/mixins/render"

module Rango
  module FormatMixin
    MIME_TYPES = Rack::Mime::MIME_TYPES
    def self.included(controller)
      controller.class_eval do
        extend ClassMethods
        extend Module.new {
          def inherited(subclass)
            subclass.formats = self.formats
          end
        }
      end
    end

    def initialize(*args)
      super(*args)
      set_content_type
    end

    def set_content_type # rango::controller
      # accept ...
    end
    def set_content_type
      super
      unless headers["Content-Type"]
        format = request.router_params[:format]
        unless format.nil?
          mime = self.class::MIME_TYPES[format]
          headers["Content-Type"] = mime
        end
      end
    end

    module ClassMethods
      attr_writer :format
      def formats
        @formats ||= Hash.new do |hash, format|
          raise BadRequest, "Unsupported format"
        end
      end

      # format(:json) do |object|
      #   object.to_json
      # end
      def format(format = nil, &block)
        if format
          self.formats[:format] = block
        else
          self.formats.default_proc = block
        end
      end
    end
  end

  module ExplicitRendering
    include Rango::RenderMixin
    def render(template, context = Hash.new)
      super(template, self.scope, self.context.merge!(context))
    end

    # class Posts < Rango::Controller
    #   def scope
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
    # This scope will be extended by same crucial methods from template mixin
    # We are in scope of current controller by default
    def scope
      Object.new.extend(Rango::Helpers)
    end

    # def show
    #   context[:post] = Post.get(params[:id])
    #   render "show.html", context
    # end
    def context
      @context ||= {request: self.request}
    end

    def get_context_value(key)
      @context[key]
    end

    def set_context_value(key, value)
      @context[key] = value
    end

    def context_keys
      @context.keys
    end
  end

  module ImplicitRendering
    include Rango::RenderMixin
    def scope
      self
    end

    def render(template) # so you can't specify context
      super template, self.scope
    end

    def get_context_value(key)
      instance_variable_get("@#{key}")
    end

    def set_context_value(key, value)
      instance_variable_set("@#{key}", value)
    end

    def context_keys
      instance_variables.map do |name|
        name[1..-1].to_sym
      end
    end
  end
end
