# encoding: utf-8

require "rango/templates/exts/tilt"
require "rubyexts/attribute"
require "rubyexts/string" # String#snake_case
require "rango/templates/helpers"
require "rango/exceptions"

module Rango
  module Errors # so we can catch it with other HTTP errors
    TemplateNotFound = Class.new(NotFound)
  end

  module Templates
    class Template
      # template -> supertemplate is the same relationship as class -> superclass
      # @since 0.0.2
      attr_accessor :path, :scope, :supertemplate

      # @since 0.0.2
      attribute :blocks, Hash.new

      # @since 0.0.2
      def initialize(path, scope = Object.new)
        self.path    = path#[scope.class.template_prefix.chomp("/"), template].join("/")
        self.scope = scope.extend(TemplateHelpers)
        self.scope._template = self
      end

      # @since 0.0.2
      def fullpath
        @fullpath ||= begin
          if self.path.match(/^(\/|\.)/) # /foo or ./foo
            Dir[self.path, "#{self.path}.*"].first
          else
            self.find_in_template_dirs
          end
        end
      end

      def adapter
        self.template.class.name.split("::").last.snake_case.sub("_template", "")
      end

      def extension # haml, erb ...
        File.extname(path)[1..-1]
      end

      def options
        @options ||= Project.settings.send(self.extension) rescue Hash.new
      end

      def template
        @template ||= Tilt.new(self.fullpath, nil, self.options)
      end

      # @since 0.0.2
      def render(context = Hash.new)
        raise Errors::TemplateNotFound.new("Template #{self.path} wasn't found in these template_dirs: #{Project.settings.template_dirs.inspect}") if self.fullpath.nil?
        value = self.template.render(self.scope, context)
        Rango.logger.info("Rendering template #{self.path}")
        Rango.logger.inspect(self.blocks)
        if self.supertemplate
          Rango.logger.debug("Extends call: #{self.supertemplate}")
          supertemplate = self.class.new(self.supertemplate, self.scope)
          supertemplate.blocks = self.blocks
          return supertemplate.render(context)
        end
        value
      end

      protected
      def find_in_template_dirs
        Project.settings.template_dirs.each do |directory|
          path = File.join(directory, self.path)
          return Dir[path, "#{path}.*"].first
        end
      end
    end
  end
end
