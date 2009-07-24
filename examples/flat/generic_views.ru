# encoding: utf-8

# rackup -p 4000 -s thin generic_views.ru
require "rango"

Rango.boot
Rango.import("mixins/mini")

# generic views
Rango.import("generic_views")

# rack-router
Rango.import("router/adapters/rack-router")

use Rango::Middlewares::Basic

use Rack::Router do |router|
  router.map "/about/:template", to: Rango::GenericViews.static
end
