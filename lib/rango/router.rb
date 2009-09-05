# encoding: utf-8

module Rango
  class Router
    @@routers = Hash.new unless defined?(@@routers)
    def self.implement(router, &block)
      @@routers[router] = block
    end

    def self.use(router)
      require_relative "router/adapters/#{router}"
      Rango.logger.debug("Using router #{router}")
      define_method(:set_rack_env, @@routers[router])
      @@router = router
    end
  end
end
