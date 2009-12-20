# encoding: utf-8

require "rango/templates/exts/tilt"
require "rango/core_ext" # String#snake_case
require "rango/templates/helpers"
require "rango/exceptions"

module Rango
  module Errors # so we can catch it with other HTTP errors
    TemplateNotFound = Class.new(NotFound)
  end

  class Template
    def self.template_paths
      @@template_paths ||= [File.join(Rango.root, "templates")]
    end

    # template -> supertemplate is the same relationship as class -> superclass
    # @since 0.0.2
    attr_accessor :path, :scope, :supertemplate

    # @since 0.0.2
    attr_writer :blocks
    def blocks
      @blocks ||= Hash.new
    end

    # @since 0.0.2
    def initialize(path, scope = Object.new)
      self.path  = path#[scope.class.template_prefix.chomp("/"), template].join("/")
      self.scope = scope.extend(TemplateHelpers)
      self.scope._template = self
    end

    # @since 0.0.2
    def fullpath
      @fullpath ||= begin
        if self.path.match(/^(\/|\.)/) # /foo or ./foo
          Dir[self.path, "#{self.path}.*"].first
        else
          self.find_in_template_paths
        end
      end
    end

    def adapter
      self.template.class.name.split("::").last.snake_case.sub("_template", "")
    end

    def extension # haml, erb ...
      File.extname(path)[1..-1]
    end

    def template(options = Hash.new)
      @template ||= Tilt.new(self.fullpath, nil, options)
    end

    # @since 0.0.2
    def render(context = Hash.new)
      raise Errors::TemplateNotFound.new("Template #{self.path} wasn't found in these template_paths: #{self.template_paths.inspect}") if self.fullpath.nil?
      value = self.template.render(self.scope, context)
      Rango.logger.info("Rendering template #{self.path}")
      # #Rango.logger.inspect(self.blocks)
      if self.supertemplate
        Rango.logger.debug("Extends call: #{self.supertemplate}")
        supertemplate = self.class.new(self.supertemplate, self.scope)
        supertemplate.blocks = self.blocks
        return supertemplate.render(context)
      end
      value
    end

    protected
    def find_in_template_paths
      self.class.template_paths.each do |directory|
        path = File.join(directory, self.path)
        return Dir[path, "#{path}.*"].first
      end
    end
  end
end
