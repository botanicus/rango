# encoding: utf-8

require "rango"
require "rango/templates/template"

module Rango
  module TemplateHelpers
    def self.extended(scope)
      class << scope
        attr_accessor :_template
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
          capture_method = "capture_#{self._template.adapter}"
          if self.respond_to?(capture_method) # tilt doesn't support @_out_buf for haml
            self.send("capture_#{self._template.adapter}", *args, &block)
          else
            # @_out_buf comes from tilt
            unless self.instance_variable_defined?("@_out_buf")
              raise "Adapter #{self._template.adapter} doesn't support capturing"
            end
            _old_buf, @_out_buf = @_out_buf, ""
            block.call(*args)
            @_out_buf = _old_buf.chomp.strip
          end
        end

        def concat(string)
          concat_method = "concat_#{self._template.adapter}"
          if self.respond_to?(concat_method) # tilt doesn't support @_out_buf for haml
            self.send("concat_#{self._template.adapter}", string)
          else
            # @_out_buf comes from tilt
            unless self.instance_variable_defined?("@_out_buf")
              raise "Adapter #{self._template.adapter} doesn't support concating"
            end
            @_out_buf << string
          end
        end
      end
    end

    def self.included(scope_class)
      scope_class.class_eval { attr_accessor :_template}
    end

    # post/show.html: it's block is the block we like to see in output
    # post/base.html
    # base.html: here it will be rendered, so we need block to returns the correct block code
    # @since 0.0.2
    # @version 0.1.1.3
    def block(name, value = nil, &block)
      raise ArgumentError, "Block has to have a name!" if name.nil?
      raise ArgumentError, "You have to provide value or block, not both of them!" if value && block
      self._template.blocks[name] ||= begin
        block ? self._template.scope.capture(&block) : value
      end
      return self._template.blocks[name]
    end

    # - extend_block(:head) do
    #   != pupu :lighter, syntax: "html", theme: "standard"
    #   != block(:head)
    def extend_block(name, value = nil, &block)
      value = self._template.scope.capture(&block) if value.nil? && block
      self._template.blocks[name] += "\n#{value}" if value
      return self._template.blocks[name]
    end

    # partial "products/list"
    # @since 0.0.2
    # @version 0.1.1.3
    def partial(template, context = Hash.new)
      if template.match(%r[/])
        path, last = File.split(template)[0..-1]
        template = File.join(path, "_#{last}")
      else
        template = "_#{template}"
      end
      template = Rango::Template.new(template, self) # self is scope
      template.supertemplate = self._template.path
      return template.render(context)
    end

    # @since 0.1.1.3
    def includes(template, context = Hash.new)
      template = Rango::Template.new(template, self) # self is scope
      template.supertemplate = self._template.path
      template.render(context)
      return true
    end

    # extends "base.html"
    # @since 0.0.2
    def extends(path)
      # we can't just create a new template, because it has to do it after it reads the whole file
      self._template.supertemplate = path
    end
  end
end
