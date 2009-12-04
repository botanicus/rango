# encoding: utf-8

module Rango
  module ExplicitRendering
    def render(template, locals = Hash.new)
      super(template, self.locals.merge!(locals))
    end
    
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
  end

  module ImplicitRendering
    def context
      self
    end

    def render(template)
      super template
    end
  end
end
