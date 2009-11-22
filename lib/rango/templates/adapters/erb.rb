# encoding: utf-8

# This adapter is intended just for little applications which we like to have without external applications or for testing. For normal application it's much better to use Erubis, which is much faster and has more useful features.

# Does NOT support:
#   - caching
#   - autoescaping
#   - contexts

require "erb"
require "rango/templates/adapter"

module Rango
  module Templates
    class ErbAdapter < Adapter
      # @since 0.0.3
      def initialize
        not_implemented("cache files") if Project.settings.template.caching
        not_implemented("autoescape")  if Project.settings.template.autoescaping
      end

      # @since 0.0.2
      def render(io, context)
        ERB.new(io.read).result(context.binding)
      end

      private
      def not_implemented(feature)
        raise NotImplementedError, "ErbAdapter don't know how to #{feature}"
      end
    end
  end

  module RenderMixin
    # ==== Parameters
    # *args:: Arguments to pass to the block.
    # &block:: The template block to call.
    #
    # ==== Returns
    # String:: The output of the block.
    #
    # ==== Examples
    # Capture being used in a .html.erb page:
    #
    #   <% @foo = capture do %>
    #     <p>Some Foo content!</p>
    #   <% end %>
    #
    # :api: private
    def capture_erb(*args, &block)
      _old_buf, @_erb_buf = @_erb_buf, ""
      block.call(*args)
      ret = @_erb_buf
      @_erb_buf = _old_buf
      ret
    end

    # :api: private
    def concat_erb(string, binding)
      @_erb_buf << string
    end
  end
end
