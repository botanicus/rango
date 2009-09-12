# encoding: utf-8

require "rack/mock"

class Factory
  class << self
    def rack_env(environment = Hash.new)
      {"PATH_INFO" => "/blog/post/a-slug", "REQUEST_METHOD" => "GET"}.merge(environment)
    end

    def request
      require "rango/rack/request"
      Rango::Request.new(self.rack_env)
    end

    def controller
      require "rango/controller"
      params = Hash.new
      Rango::Controller.new(self.request, params)
    end
  end
end
