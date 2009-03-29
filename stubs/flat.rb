# coding=utf-8

require "rango"

Rango.boot(:flat => true)
Rango.run

Project.configure do
  # TODO
end

Rango::CallableStrategy.new.register

Rango::Router.register do
  # TODO
end