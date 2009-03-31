# coding=utf-8

require "erb"

# TODO: documentation
# TODO: specs
class SettingsNotFound < StandardError
end

class TemplateNotFound < StandardError
  # @since 0.0.2
  attr_accessor :message

  # @since 0.0.2
  def initialize(template, locations)
    self.message = "Template '#{template}' wasn't found in any of these locations: #{locations.join(", ")}."
  end
end

# @since 0.0.1
class AnyStrategyMatched < StandardError
end

# @since 0.0.2
class SkipFilter < StandardError
end

# @since 0.0.2
class SkipRoute < StandardError
end

# superclass of all the controller exceptions
class Rango
  module HttpExceptions
    class HttpError < StandardError
      # @since 0.0.1
      attr_accessor :status, :params
      
      # @since 0.0.1
      def initialize(status, params = nil)
        self.status = status
        self.params = params
      end

      # @since 0.0.1
      def headers
        {'Content-Type' => 'text/html'}
      end

      # @since 0.0.1
      def render
        content = Rango.framework.path.join("../../templates/errors/#{self.status}.html.erb").read
        ERB.new(content).result(binding)
      end

      # @since 0.0.1
      def call(env)
        return [self.status, self.headers, self.body]
      end
    end

    class Error404 < HttpError
      # @since 0.0.1
      attr_accessor :params

      # @since 0.0.1
      def initialize(params = nil)
        super("404")
      end

      # @since 0.0.1
      def body
        @routes = Project.router.routes
        @router = Project.settings.router
        self.render
      end
    end

    class Error406 < HttpError
      # @since 0.0.1
      attr_accessor :params
      
      # @since 0.0.1
      def initialize(params)
        super("406")
      end

      # @since 0.0.1
      def body
        self.render
      end
    end

    class Error500 < HttpError
      # @since 0.0.1
      attr_accessor :exception, :params
      
      # @since 0.0.1
      def initialize(exception, params)
        super("500")
        self.exception = exception
        self.params = params
      end

      # @since 0.0.1
      def body
        self.render
        # ["<h1>#{exception.message}</h2>", '@exception.bactrace.join("<br />")']
      end
    end
  end
end