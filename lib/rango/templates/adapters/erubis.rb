# encoding: utf-8

require "erubis"
Rango.import("templates/adapter")

class Rango
  module Templates
    class Erubis < ::Rango::Templates::Adapter
      # TODO: context {foo: "bar"} => @foo instead of just foo
      # http://www.kuwata-lab.com/erubis/users-guide.02.html#tut-context

      # TODO: result vs. evaluate
      # http://www.kuwata-lab.com/erubis/users-guide.02.html#tut-context
      # http://www.kuwata-lab.com/erubis/users-guide.06.html#topics-context-vs-binding

      # TODO: maybe preprocessing
      # http://www.kuwata-lab.com/erubis/users-guide.05.html#rails-preprocessing
      # http://www.kuwata-lab.com/erubis/users-guide.06.html#topics-caching

      # @since 0.0.2
      # @see http://www.kuwata-lab.com/erubis/users-guide.02.html#tut-escape
      def render(io, context)
        if Project.settings.erubis.custom_class
          klass = Project.settings.erubis.custom_class
        elsif Project.settings.autoescape
          klass = ::Erubis::EscapedEruby
        else
          klass = ::Erubis::Eruby
        end
        pattern = Project.settings.erubis_pattern
        klass.new(io.read).result(context, binding, pattern: pattern)
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
    def capture_erubis(*args, &block)
      _old_buf, @_erb_buf = @_erb_buf, ""
      block.call(*args)
      ret = @_erb_buf
      @_erb_buf = _old_buf
      ret
    end
  end
end