# encoding: utf-8

# TODO: qattribute :partial, true
# => define #partial?

module Rango
  module Templates
    class Template
      # template -> supertemplate is the same relationship as class -> superclass
      # @since 0.0.2
      attr_accessor :template, :context, :locals, :supertemplate

      # @since 0.0.2
      attribute :blocks, Hash.new

      # @since 0.0.2
      attribute :partial, false

      # @since 0.0.2
      def initialize(template, context, locals = Hash.new)
        self.template = template#[context.class.template_prefix.chomp("/"), template].join("/")
        self.context  = context
        self.locals   = locals
      end

      # @since 0.0.2
      def render
        @body ||= begin
          self.context = extend_context(self.context) unless self.partial
          path = self.find(self.template)
          raise TemplateNotFound.new(template, Project.settings.template_dirs) if path.nil?
          file = File.new(path)
          value = self.engine.render(file, context, self.locals)
          STDOUT.puts
          Rango.logger.info("Rendering template #{self.template}")
          # Rango.logger.inspect(self.blocks)
          if self.supertemplate
            Rango.logger.debug("Extends call: #{self.supertemplate}")
            supertemplate = self.class.new(self.supertemplate, self.context, self.locals)
            supertemplate.blocks = self.blocks
            return supertemplate.render
          end
          return value
        end
      end

      # @since 0.0.2
      def extend_context(context)
        class << context
          include TemplateHelpers
          attr_accessor :_template
        end
        context._template = self
        return context
      end

      # @since 0.0.2
      def engine
        # TODO: test if Project.settings.template_engine nil => useful message
        # TODO: maybe more template engines?
        engine_name = Project.settings.template_engine
        Rango.import("templates/adapters/#{engine_name}.rb")
        engine_class = Rango::Templates.engine(engine_name)
        engine_class.new
      rescue LoadError
        Rango.logger.fatal("Template engine #{engine_name} can't be loaded.")
        raise Error406.new(self.params)
      end

      def mtime
        @mtime ||= File.mtime(self.template)
      end

      # @since 0.0.2
      def find(template)
        if template.match(/^\//)
          if File.exist?(template)
            return template
          elsif template = Dir["#{template}.*"].first
            return template
          end
        else
          Project.settings.template_dirs.each do |directory|
            path = File.join(directory, template)
            if File.exist?(path)
              return path
            elsif first = Dir["#{path}.*"].first
              return first
            end
          end
          return nil
        end
      end
    end

    module TemplateHelpers
      # post/show.html: it's block is the block we like to see in output
      # post/base.html
      # base.html: here it will be rendered, so we need block to returns the correct block code
      # @since 0.0.2
      def block(name, value = nil, &block)
        value = self._template.context.capture(&block) if value.nil? && block
        self._template.blocks[name] ||= value
        return self._template.blocks[name]
      end

      # partial "products/list"
      # @since 0.0.2
      def partial(template, locals = Hash.new)
        if template.match(%r[/])
          path, last = File.split(template)[0..-1]
          template = File.join(path, "_#{last}")
        else
          template = "_#{template}"
        end
        template = Rango::Templates::Template.new(template, self._template.context, locals)
        template.partial = true
        # TODO: #block in partial templates
        output = template.render
        # Rango.logger.debug("Partial: #{output[0..20]} ...")
        return output
      end

      # extends "base.html"
      # @since 0.0.2
      def extends(template)
        self._template.supertemplate = template
      end
    end
  end
end
