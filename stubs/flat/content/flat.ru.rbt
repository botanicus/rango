# coding: utf-8

# rackup -p 4000 -s thin flat.ru
require "rango"

Rango.boot(flat: true)

Project.configure do
  # TODO
end

Rango::CallableStrategy.register

Rango::Router.register do
  match("/").to do |request|
    "<h1>Rango is just Awesome!</h1>"
  end
end

run Rango.app
