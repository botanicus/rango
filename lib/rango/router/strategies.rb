class Rango
  class RouterStrategy
    def register
      # TODO: different strategies for each router
      Rango::Router.strategies.push(self)
    end
  end

  # to("Post#show", "blog/views")
  # => Post.new(request).show(*args)
  class ControllerStrategy < RouterStrategy
    def match?(route)
      route.file && route.callable.is_a?(String)
    end

    def run(route, request, params)
      Project.import(route.file) if route.file
      args = params.map { |key, value| value }
      klass, method = route.callable.split("#")
      controller = klass.new
      controller.request = request
      controller.params  = params
      controller.method(method).call(*args)
    end
  end

  # to(Rango.logger.method(:debug))
  # => Rango.logger.debug(request, *args)
  class CallableStrategy < RouterStrategy
    def match?(route)
      (not route.file) && route.callable.respond_to?(:call)
    end

    def run(route, request, params)
      args = params.map { |key, value| value }
      route.callable.call(request, *args)
    end
  end
end
