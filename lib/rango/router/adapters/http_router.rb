# encoding: utf-8

begin
  require "http_router"
rescue LoadError
  raise LoadError, "You have to install http_router gem!"
end

Rango::Router.implement(:http_router) do |env|
  env["rango.router.params"] = env["router.params"] || Hash.new # TODO: nil
end

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      Rango::Router.app.url(*args)
    end
  end
end
