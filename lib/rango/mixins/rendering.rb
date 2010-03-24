# encoding: utf-8

require "rango/mixins/render"

module Rango
  module FormatMixin
    def self.extended
    end

    def inherited
    end

    attr_writer :format
    def formats
      @formats ||= Hash.new { |hash, format| hash[:html] if hash.has_key?(:html) }
    end

    # format(:json) do |object|
    #   object.to_json
    # end
    def format(format, &block)
      self.formats[:format] = block
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
