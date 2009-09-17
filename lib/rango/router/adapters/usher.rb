# encoding: utf-8

require "usher"

Rango::Router.implement(:usher) do |env|
  env["rango.router.params"] = env["usher.params"]
  env["rango.router.app"] = self
end

module Rango
  class Controller
    # url(:login)
    def url(*args)
      Project.router.router.generator.generate(*args)
    end
  end
end
