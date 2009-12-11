# encoding: utf-8

require "rango/mixins/render"

module Rango
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
  end

  module ImplicitRendering
    include Rango::RenderMixin
    def scope
      self
    end

    def render(template) # so you can't specify context
      super template, self.scope
    end
  end
end
