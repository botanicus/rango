#!/usr/bin/env rackup -p 4000 -s thin
# encoding: utf-8

require "rango"
require "rango/mixins/mini"

Rango.boot
Rango::Router.use(:urlmap)

# 1) Basic Rack way how to return response
map("/about/version/1") do
  # setup Content-Length and Content-Type headers
  # (both these middlewares are included in Rango::Dispatcher),
  # so you can also do use Rango::Middlewares::Basic
  # use Rack::ContentLength
  # use Rack::ContentType
  use Rango::Middlewares::Basic
  run lambda { |env| [200, Hash.new, "Rango version: #{Rango::VERSION}"] }
end

# 2) Rack way how to return response via Rack API
# You can use Response#status= and Rack#[]= if you need to setup status resp. headers
# http://rack.rubyforge.org/doc/classes/Rack/Response.html
map("/about/version/2") do
  run lambda { |env| Response.new("Rango version: #{Rango::VERSION}").finish }
end

# 3) Rango-specific way
map("/about/version/3") do
  run app { |request, response| "Rango version: #{Rango::VERSION}" }
end
