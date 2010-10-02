# encoding: utf-8

# Use with explicit or implicit rendering mixin
module Rango
  module ConventionalRendering
    def self.template_dirname=(template_dirname)
      @@template_dirname = template_dirname
    end

    def self.template_dirname
      @@template_dirname
    rescue NameError
      name     = self.class.name
      constant = name.gsub("::", "/")
      dirname  = constant.camel_case
      @@template_dirname = dirname
    end

    def template_dirname
      self.class.template_dirname
    end

    # @example
    #   def template_basename
    #     case request["router.action"]
    #     when "show"
    #       self.class.name.singularize
    #     when "index"
    #     else
    #     end
    #   end
    #
    # @api plugin
    def template_basename
      request["router.action"]
    end

    def template_path
      File.join(template_dirname, template_basename)
    end

    def render_relative(template, context = nil)
      if context
        super File.join(template_dirname, template), context
      else
        super File.join(template_dirname, template)
      end
    end

    def autorender(context = nil)
      if context
        render_relative template_basename, context
      else
        render_relative template_basename
      end
    end

    def display(object)
      autorender
    rescue TemplateInheritance::TemplateNotFound
      callback = self.formats[request.action]
      callback.call
    end
  end
end
