# encoding: utf-8

require "rack/router"

Rango::Router.implement(:rack_router) do |env|
  env["rango.router.params"] = env["rack_router.params"]
  env["rango.router.app"] = self
end
