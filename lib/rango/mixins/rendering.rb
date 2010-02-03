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
  module StackRendering
    include Rango::RenderMixin
    def template_dirname
      self.class.name.gsub("::", "/").camel_case
    end

    def template_basename
      request["router.action"]
    end

    #def template_basename
    #  case request["router.action"]
    #  when "show"
    #    self.class.name.singularize
    #  when "index"
    #  else
    #  end
    #end

    def template_path
      File.join(template_dirname, template_basename)
    end

    def render(context = Hash.new)
      super(self.template_path, self.scope, self.context.merge!(context))
    end

    def display(object)
      render
    rescue TemplateNotFound
      callback = self.formats[request.action]
      callback.call
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
