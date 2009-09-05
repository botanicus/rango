#!/usr/bin/env rackup -p 4000 -s thin
# encoding: utf-8

require "rango"
require "rango/mixins/mini"
require "rango/generic_views"

Rango.boot

# rack-router
Rango::Router.use(:rack_router)
use Rango::Middlewares::Basic

use Rack::Router do |router|
  router.map "/about/:template", to: Rango::GenericViews.static
end
