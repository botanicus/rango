# encoding: utf-8

require "usher"

Rango::Router.implement(:usher) do |env|
  env["rango.router.params"] = env["usher.params"]
end

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      raise "You have to asign your routes to Project.router, for example Project.router = Usher::Interface.for(:rack) { get('/') }" if Project.router.nil?
      Project.router.router.generator.generate(*args)
    end
  end
end
