# encoding: utf-8

# Rack::URLMap is very easy router included directly in rack distribution
# You can't use stuff like "posts/:id" there, so env["rango.router.params"]
# allways will be just empty hash

Rango::Router.implement(:urlmap) do |env|
  env["rango.router.params"] = Hash.new
end
