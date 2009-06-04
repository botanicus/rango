# coding: utf-8

require "rack/router"
Rango.import("router/dispatcher")

class Rango
  class Router
    module RackRouter
      def set_rack_env(env)
        env["rango.router.params"] = env["rack_router.params"]
        env["rango.router.app"] = self
      end

      # register it
      Rango::Router::Dispatcher.router_adapter = self
    end
  end
end
