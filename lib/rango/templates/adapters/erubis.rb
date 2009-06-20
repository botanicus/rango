# encoding: utf-8

# Features:
#   - autoescaping
#   - caching
#   - preprocessing (not yet, see ticket #68)

require "erubis"
Rango.import("templates/adapter")

# TODO: fast a escaped dohromady
module Rango
  module Templates
    class ErubisAdapter < Adapter
      # @since 0.0.2
      def render(io, context = Hash.new)
        if Project.settings.erubis.custom_class
          klass = Project.settings.erubis.custom_class
        elsif Project.settings.template.autoescape
          klass = Erubis::EscapedEruby
        else
          klass = Erubis::FastEruby
        end
        pattern = Project.settings.erubis.pattern
        # Erubis::Engine.load_file is good for caching
        # http://www.kuwata-lab.com/erubis/users-guide.06.html#topics-caching
        if Project.settings.template.caching
          begin
            template = klass.load_file(io.path, pattern: pattern, filename: io.path)
          rescue NoMethodError
            Rango.logger.error("Class #{klass} must respond to load_file method if you like to use caching")
          end
        else
          template = klass.new(io.read, pattern: pattern, filename: io.path)
        end
        template.extend(CaptureErubis)
        return template.result(context)
      end
    end
  end

  module CaptureErubis
    # @example Capture being used in a .html.erb page:
    #   <% @foo = capture do %>
    #     <p>Some Foo content!</p>
    #   <% end %>
    #
    # @params [*args]  Arguments to pass to the block.
    # @params [&block] The template block to call.
    # @return [String] The output of the block.
    # @api private
    def capture_erubis(*args, &block)
      _old_buf, @_erb_buf = @_erb_buf, ""
      block.call(*args)
      @_erb_buf.dup.tap do |buf|
        @_erb_buf = _old_buf
      end
    end
  end
end
