# encoding: utf-8

require "rango/templates/exts/tilt"
require "rango/core_ext" # String#snake_case
require "rango/templates/helpers"
require "rango/exceptions"

module Rango
  module Exceptions # so we can catch it with other HTTP errors
    TemplateNotFound = Class.new(NotFound) { self.name = "Template Not Found" }
  end

  class Template
    def self.template_paths
      @@template_paths ||= [Rango.root.join("templates").to_s]
    end

    # template -> supertemplate is the same relationship as class -> superclass
    # @since 0.0.2
    attr_accessor :path, :scope, :supertemplate, :context

    # @since 0.0.2
    attr_writer :blocks
    def blocks
      @blocks ||= Hash.new
    end

    # @since 0.0.2
    def initialize(path, scope = Object.new)
      self.path  = path#[scope.class.template_prefix.chomp("/"), template].join("/")
      self.scope = scope.extend(TemplateHelpers)
      self.scope.template = self
    end

    # @since 0.0.2
    def fullpath
      @fullpath ||= begin
        if self.path.match(/^(\/|\.)/) # /foo or ./foo
          Dir[self.path, "#{self.path}.*"].find {|file| !File.directory?(file)}
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
      raise Exceptions::TemplateNotFound.new("Template #{self.path} wasn't found in these template_paths: #{self.class.template_paths.inspect}") if self.fullpath.nil?
      Rango.logger.info("Rendering template #{self.path} with context keys #{context.keys.inspect}")
      self.scope.context = self.context = context # so we can access context in the scope object as well
      value = self.template.render(self.scope, context)
      Rango.logger.debug("Available blocks: #{self.blocks.keys.inspect}")
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
        return Dir[path, "#{path}.*"].find {|file| !File.directory?(file)}
      end
    end
  end
end
