# encoding: utf-8

require "rango"
require "rango/templates/template"

module Rango
  module TemplateHelpers
    def self.extended(scope)
      class << scope
        attr_accessor :template
        # @example Capture being used in a .html.erb page:
        #   <% @foo = capture do %>
        #     <p>Some Foo content!</p>
        #   <% end %>
        #
        # @params [*args]  Arguments to pass to the block.
        # @params [&block] The template block to call.
        # @return [String] The output of the block.
        # @api private
        def capture(*args, &block)
          capture_method = "capture_#{self.template.adapter}"
          if self.respond_to?(capture_method) # tilt doesn't support @_out_buf for haml
            self.send("capture_#{self.template.adapter}", *args, &block)
          else
            # @_out_buf comes from tilt
            unless self.instance_variable_defined?("@_out_buf")
              raise "Adapter #{self.template.adapter} doesn't support capturing"
            end
            _old_buf, @_out_buf = @_out_buf, ""
            block.call(*args)
            @_out_buf = _old_buf.chomp.strip
          end
        end

        def concat(string)
          concat_method = "concat_#{self.template.adapter}"
          if self.respond_to?(concat_method) # tilt doesn't support @_out_buf for haml
            self.send("concat_#{self.template.adapter}", string)
          else
            # @_out_buf comes from tilt
            unless self.instance_variable_defined?("@_out_buf")
              raise "Adapter #{self.template.adapter} doesn't support concating"
            end
            @_out_buf << string
          end
        end
      end
    end

    def self.included(scope_class)
      scope_class.class_eval { attr_accessor :template}
    end

    # post/show.html: it's block is the block we like to see in output
    # post/base.html
    # base.html: here it will be rendered, so we need block to returns the correct block code
    # @since 0.0.2
    # @version 0.2
    def block(name, value = nil, &block)
      raise ArgumentError, "Block has to have a name!" if name.nil?
      raise ArgumentError, "You have to provide value or block, not both of them!" if value && block
      self.template.blocks[name] ||= block ? self.template.scope.capture(&block) : value
      return self.template.blocks[name]
    end

    # - extend_block(:head) do
    #   = pupu :lighter, syntax: "html", theme: "standard"
    #   = block(:head)
    def extend_block(name, value = nil, &block)
      unless self.template.blocks[name]
        raise NameError, "Block #{name.inspect} wasn't defined yet, you can't extend it!"
      end
      self.enhance_block(name, value, &block)
    end

    def enhance_block(name, value = nil, &block)
      raise ArgumentError, "Block has to have a name!" if name.nil?
      raise ArgumentError, "You have to provide value or block, not both of them!" if value && block
      value = self.template.scope.capture(&block) if value.nil? && block
      self.template.blocks[name] = "#{self.template.blocks[name]}\n#{value}" if value
      return self.template.blocks[name]
    end

    # Low-level rendering method for templates.
    #
    # @since 0.2
    # @example
    #   render "base.html"
    #   render "./base.html"
    #   render "../base.html"
    def render(template, context = Hash.new)
      normalize_template_path(template)
      original_template = self.template
      template = Rango::Template.new(template, self) # self is scope
      self.template = original_template
      return template.render(context)
    end

    # partial "products/list"
    # @since 0.0.2
    # @version 0.2.1
    def partial(template, extra_context = Hash.new)
      # NOTE: we can't use File.split because it normalize the path,
      # so "./base.html" will be the same as "base.html", but it shouldn't be
      *path, basename = template.split("/")
      render File.join(*path, "_#{basename}"), self.template.context.merge(extra_context)
    end

    # @since 0.2
    def includes(template, context = Hash.new)
      render template, context
      return true
    end

    # extends "base.html"
    # @since 0.0.2
    def extends(path)
      # we can't just create a new template, because it has to do it after it reads the whole file
      self.template.supertemplate = normalize_template_path(path)
    end

    # @since 0.2
    def normalize_template_path(template)
      if template.start_with?("./")
        File.expand_path(File.join(File.dirname(self.template.fullpath), template))
      elsif template.start_with?("../")
        File.expand_path(File.join(File.dirname(self.template.fullpath), "..", template))
      else
        template
      end
    end
  end
end
