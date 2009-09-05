# encoding: utf-8

module Rango
  class Router
    @@routers = Hash.new unless defined?(@@routers)
    def self.implement(router, &block)
      @@routers[router] = block
    end

    def self.use(router)
      raise ArgumentError unless @@routers.include?(router)
      Rango.logger.debug("Using router #{router}")
      define_method(:set_rack_env, @@routers[router])
      @@router = router
    end

    module Dispatcher
      class << self
        attr_accessor :router_adapter
        def included(klass)
          self.install_hook(klass)
        end

        def extended(object)
          self.install_hook(object.class)
        end

        def install_hook(klass)
          klass.send(:include, self.router_adapter)
        rescue TypeError
          raise TypeError, "You must set the Dispatcher.router_adapter first. For example Dispatcher.router_adapter = Rango::Router::RackRouter"
        end

        def route_to(env, app)
          Rango.logger.inspect("Routing request to #{app.inspect}")
          app.call(env)
        end
      end
    end
  end
end
