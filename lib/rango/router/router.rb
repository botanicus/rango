# coding=utf-8

# TODO: includes
# TODO: documentation
# TODO: specs

Rango.import("router/strategies")
Rango.import("router/route")

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
end
