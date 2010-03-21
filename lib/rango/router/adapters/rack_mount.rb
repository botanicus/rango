# encoding: utf-8

begin
  require "rack/mount"
rescue LoadError
  raise LoadError, "You have to install rack-mount gem!"
end

Rango::Router.implement(:rack_mount) do |env|
  env["rango.router.params"] = env["rack.routing_args"]
end

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      Rango::Router.app.url(*args)
    end
  end
end
