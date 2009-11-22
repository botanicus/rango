# encoding: utf-8

require "rack/mount"

Rango::Router.implement(:rack_mount) do |env|
  env["rango.router.params"] = env["rack.routing_args"]
  env["rango.router.app"] = self
end

module Rango
  class Controller
    # url(:login)
    def url(*args)
      Project.router.url(*args)
    end
  end
end
