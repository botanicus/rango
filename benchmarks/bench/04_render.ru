# encoding: utf-8

require "simple-logger"
require "rango/controller"
require "rango/mixins/rendering"

class App < Rango::Controller
  include Rango::ExplicitRendering
  def test
    render "content.html"
  end
end

Rango::Router.use(:rack_router)

Rack::Handler::Thin.run(App.dispatcher(:test), Port: 4004)
