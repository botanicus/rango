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

    attribute :routes, Array.new
    def initialize
      self.routes = Array.new
    end

    # match("kontakt/", :method => "get")
    def match(pattern, params = Hash.new, &block)
      if pattern.is_a?(String)
        escaped = Regexp::quote(pattern)
        pattern = %r[^#{escaped}]
      end
      route = Route.new
      route.match_pattern = pattern
      route.match_params = params
      @routes.push(route)
      return route
    end

    def include(*args)
      return self
    end

    def redirect(url)
      # TODO
    end

    def inspect
      @routes.inspect
    end

    def find(uri)
      route = @routes.find { |route| route.match?(uri) }
      route = Error404.new unless route
      return route
    end
  end

  class Route
    # %r[blog/post]
    attribute :match_pattern
    # {:method => "get"}
    attribute :match_params, Hash.new
    attribute :strategy
    attribute :params, Hash.new # FIXME: nemuze to takhle ukazovat pro vsechny routy na stejnej hash?
    # to(Rango.logger.method(:debug)), to("blog/views", "Post#show")
    attribute :arguments, Array.new
    # {:page => 1}
    # will be merged with params
    attribute :default_params, Hash.new
    attribute :block

    # TODO: full const get
    # to(Rango.logger.method(:debug))
    # => Rango.logger.debug(request, *args)
    # to("Post#show", "blog/views")
    # => Post.new(request).show(*args)
    def to(*args, &block)
      self.arguments = args
      self.block = block
      return self
    end

    def call(request)
      strategy = self.strategy || Router.strategies.find { |strategy| strategy.match?(request, self.default_params, *self.arguments, &self.block) }
      raise(AnyStrategyMatched) unless strategy
      begin
        params = self.default_params.merge(self.params)
        strategy.run(request, params, *self.arguments, &self.block)
      rescue Exception => exception
        if exception.class.superclass.eql?(Rango::ControllerExceptions)
          raise exception
        else
          Project.logger.exception(exception)
          Project.logger.debug("strategy: #{strategy.inspect}")
          Project.logger.debug("route: #{self.inspect}")
          # raise Error500.new(exception)
          Error500.new(exception).call(request)
        end
      end
    end
    
    # default(:page => 1)
    def default(params)
      self.default_params = params
    end

    def match?(uri)
      data = uri.match(@match_pattern)
      unless data.nil?
        data.names.each { |argument| self.params[argument.to_sym] = data[argument] }
      end
      return data
    end
  end
end
