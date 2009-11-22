# encoding: utf-8

require "usher"

Rango::Router.implement(:usher) do |env|
  env["rango.router.params"] = env["usher.params"]
  env["rango.router.app"] = self
end

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      Project.router.router.generator.generate(*args)
    end
  end
end
