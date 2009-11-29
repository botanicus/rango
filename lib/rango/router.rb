# encoding: utf-8

require "rango" # for helpers

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      raise "Your router or your router adapter doesn't support this method"
    end
  end

  Helpers.send(:include, UrlHelper)

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
