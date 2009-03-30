# coding=utf-8

require "erb"

# TODO: documentation
# TODO: specs
class SettingsNotFound < StandardError
end

class TemplateNotFound < StandardError
  attr_accessor :message
  def initialize(template, locations)
    self.message = "Template '#{template}' wasn't found in any of these locations: #{locations.join(", ")}."
  end
end

class AnyStrategyMatched < StandardError
end

class SkipFilter < StandardError
end

class SkipRoute < StandardError
end

# superclass of all the controller exceptions
class Rango
  module HttpExceptions
    class HttpError < StandardError
      attr_accessor :status, :params
      def initialize(status, params = nil)
        self.status = status
        self.params = params
      end

      def headers
        {'Content-Type' => 'text/html'}
      end

      def render
        content = Rango.framework.path.join("../../templates/errors/#{self.status}.html.erb").read
        ERB.new(content).result(binding)
      end

      def call(env)
        return [self.status, self.headers, self.body]
      end
    end

    class Error404 < HttpError
      attr_accessor :params
      def initialize(params = nil)
        super("404")
      end

      def body
        @routes = Project.router.routes
        @router = Project.settings.router
        self.render
      end
    end

    class Error406 < HttpError
      attr_accessor :params
      def initialize(params)
        super("406")
      end

      def body
        self.render
      end
    end

    class Error500 < HttpError
      attr_reader :exception, :params
      def initialize(exception, params)
        super("500")
        self.exception = exception
        self.params = params
      end

      def body
        self.render
        # ["<h1>#{exception.message}</h2>", '@exception.bactrace.join("<br />")']
      end
    end
  end
end