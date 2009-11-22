#!/usr/bin/env rackup -s thin -p 4000
# encoding: utf-8

# rackup -p 4000 -s thin flat.ru
require "rango"
require "rango/mixins/mini"

Rango.boot

use Rango::Basic

Project.configure do
  # TODO
end

# router
require "rango/router/adapters/basic"

map("/") do
  run app { "<h1>Rango is just Awesome!</h1>" }
end
