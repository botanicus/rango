# coding=utf-8

# TODO: includes
# TODO: documentation
# TODO: specs

Rango.import("router/strategies")

class Rango
  class Router
    include Rango::HttpExceptions
    class << self
      # @since 0.0.1
      attribute :routers, Array.new

      # @since 0.0.1
      attribute :strategies, Array.new

      # @since 0.0.1
      def register(&block)
        router = self.new
        router.instance_eval(&block)
        routers.push(router)
        Project.router = router # FIXME
        return router
      end

      # @since 0.0.1
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

    # match("kontakt/", method: "get")
    # Regexp#source returns the string representation
    # @since 0.0.1
    def match(pattern, params = Hash.new, &block)
      if pattern.is_a?(String)
        escaped = Regexp::quote(pattern)
        pattern = %r[^#{escaped}/?$]
      end
      route = Route.new
      route.match_pattern = pattern
      route.match_params = params
      @routes.push(route)
      return route
    end

    # @since 0.0.1
    def include(*args)
      return self
    end

    def redirect(url)
      # TODO
    end

    # @since 0.0.1
    def inspect
      @routes.inspect
    end

    # @since 0.0.1
    def find(uri)
      route = @routes.find { |route| route.match?(uri) }
      raise Error404.new unless route
      return route
    end
  end

  class Route
    include Rango::HttpExceptions
    # %r[blog/post]
    # @since 0.0.1
    attribute :match_pattern

    # {method: "get"}
    # @since 0.0.1
    attribute :match_params, Hash.new

    # @since 0.0.1
    attribute :strategy

    # @since 0.0.1
    attribute :params, Hash.new # FIXME: nemuze to takhle ukazovat pro vsechny routy na stejnej hash?

    # to(Rango.logger.method(:debug)), to("blog/views", "Post#show")
    # @since 0.0.1
    attribute :arguments, Array.new

    # {page: 1}
    # will be merged with params
    # @since 0.0.1
    attribute :default_params, Hash.new
    
    # @since 0.0.1
    attribute :block

    # TODO: full const get
    # to(Rango.logger.method(:debug))
    # => Rango.logger.debug(request, *args)
    # to("Post#show", "blog/views")
    # => Post.new(request).show(*args)
    # @since 0.0.1
    def to(*args, &block)
      self.arguments = args
      self.block = block
      return self
    end

    # @since 0.0.1
    def call(request)
      strategy = self.find_strategy(request)
      raise(AnyStrategyMatched) unless strategy
      params = self.default_params.merge(self.params)
      strategy.run(request, params, *self.arguments, &self.block)
    rescue Exception => exception
      Project.logger.exception(exception)
      Project.logger.debug("strategy: #{strategy.inspect}")
      Project.logger.debug("route: #{self.inspect}")
      raise Error500.new(exception, self.params)
    end

    # @since 0.0.1
    def find_strategy(request)
      self.strategy || Router.strategies.find { |strategy| strategy.match?(request, self.default_params, *self.arguments, &self.block) }
    end

    # default(page: 1)
    # @since 0.0.1
    def default(params)
      self.default_params = params
    end

    # @since 0.0.1
    def match?(uri)
      data = uri.match(@match_pattern)
      unless data.nil?
        data.names.each { |argument| self.params[argument.to_sym] = data[argument] }
      end
      return data
    end
  end
end
