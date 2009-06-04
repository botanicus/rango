# coding: utf-8

# Rack::URLMap is very easy router included directly in rack distribution
# You can't use stuff like "posts/:id" there, so env["rango.router.params"]
# allways will be just empty hash

Rango.import("router/dispatcher")

class Rango
  class Router
    module Basic
      def set_rack_env(env)
        env["rango.router.params"] = Hash.new
        env["rango.router.app"] = self
      end

      # register it
      Rango::Router::Dispatcher.router_adapter = self
    end
  end
end
