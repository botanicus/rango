# encoding: utf-8

require "erb"
Rango.import("templates/adapter")

class Rango
  module Templates
    class Erb < ::Rango::Templates::Adapter
      # @since 0.0.2
      def render(io, context)
        ::ERB.new(io.read).result(context.binding)
      end
    end
  end

  class Controller
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