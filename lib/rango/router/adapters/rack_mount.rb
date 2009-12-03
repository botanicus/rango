# encoding: utf-8

require "rack/mount"

Rango::Router.implement(:rack_mount) do |env|
  env["rango.router.params"] = env["rack.routing_args"]
end

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      Project.router.url(*args)
    end
  end
end
