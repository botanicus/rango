class SettingsNotFound < StandardError
end

class AnyStrategyMatched < StandardError
end

# superclass of all the controller exceptions
class Rango
  class ControllerExceptions
    attr_reader :status
    def initialize(status)
      @status = status
    end
    
    def headers
      {'Content-Type' => 'text/html'}
    end
    
    def content_length
      lengths = self.body.map { |line| line.length }
      length  = lengths.inject { |sum, item| sum + item }
      {'Content-Length' => length.to_s}
    end
    
    def call(env)
      headers = self.headers.merge(content_length)
      return [self.status, headers, self.body]
    end
  end

  class Error404 < ControllerExceptions
    def initialize
      super("404")
    end

    def call(request)
      # request.status = 500
      routes = Project.router.routes.map { |route| route.match_pattern.inspect + " " + route.match_params.inspect}
      actual = request.path
      ["<h1>404 Page Not Found</h1>", "URL was <code>#{actual}</code>", "<h2>Available routes</h2>", routes.join("<br />")]
    end
  end
  
  class Error500 < ControllerExceptions
    attr_reader :exception
    def initialize(exception)
      super("500")
      @exception = exception
      @body = ["<h1>#{exception.message}</h2>", '@exception.bactrace.join("<br />")']
    end
    
    def call(request)
      # request.status = 500
      ["<h1>500 Internal Server Error</h1>", "TODO: backtraces"]
    end
  end
end