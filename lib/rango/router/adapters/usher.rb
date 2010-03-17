# encoding: utf-8

require "usher"

Rango::Router.implement(:usher) do |env|
  # when usher routes to the default app, then usher.params is nil
  env["rango.router.params"] = env["usher.params"] || Hash.new
end

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      Rango::Router.app.router.generator.generate(*args)
    end
  end
end
