# encoding: utf-8

require "usher"

Rango::Router.implement(:usher) do |env|
  env["rango.router.params"] = env["usher.params"]
  env["rango.router.app"] = self
end
