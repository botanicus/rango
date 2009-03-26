# TODO: Router can handle subdomains
# TODO: includes

Rango.import("router/strategies")

class Rango
  class Router
    class << self
      attribute :routers, Array.new
      attribute :strategies, Array.new
      def register(&block)
        router = self.new
        router.instance_eval(&block)
        routers.push(router)
        Project.router = router # FIXME
        return router
      end

      def find(uri)
        routers.each do |router|
          router.find(uri)
        end
      end
    end

    def initialize
      @routes = Array.new
    end

    def match(pattern, &block)
      if pattern.is_a?(String)
        escaped = Regexp::quote(pattern)
        pattern = %r[^#{escaped}]
      end
      route = Route.new
      route.pattern = pattern
      @routes.push(route)
      return route
    end

    def include(*args)
      return self
    end

    def redirect(url)
    end

    def inspect
      @routes.inspect
    end

    def find(uri)
      @routes.find do |route|
        route.match?(uri)
      end
    end
  end

  class Route
    attribute :pattern
    attribute :strategy
    attribute :callable
    attribute :params, Hash.new # FIXME: nemuze to takhle ukazovat pro vsechny routy na stejnej hash?
    attribute :file

    # TODO: full const get
    # to(Rango.logger.method(:debug))
    # => Rango.logger.debug(request, *args)
    # to("Post#show", "blog/views")
    # => Post.new(request).show(*args)
    def to(callable = nil, file = nil, &block)
      self.callable = callable || block
      raise "TODO: write error class" unless self.callable
      self.file = file
      return self
    end

    def call(request)
      strategy = self.strategy || Router.strategies.find { |strategy| strategy.match?(self) }
      raise(AnyStrategyMatched) unless strategy
      strategy.run(self, request, self.params)
    end

    def match?(uri)
      data = uri.match(@pattern)
      unless data.nil?
        data.names.each { |argument| self.params[argument.to_sym] = data[argument] }
      end
      return data
    end
  end
end

# TODO: user should register strategies
Rango::ControllerStrategy.new.register
Rango::CallableStrategy.new.register
