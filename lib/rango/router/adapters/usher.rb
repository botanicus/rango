# encoding: utf-8

require "usher"

Rango::Router.implement(:usher) do |env|
  env["rango.router.params"] = env["usher.params"]
end

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      raise "You have to asign your routes to Rango::Router.app, for example Rango::Router.app = Usher::Interface.for(:rack) { get('/') }" if Rango::Router.app.nil?
      Rango::Router.app.router.generator.generate(*args)
    end
  end
end
