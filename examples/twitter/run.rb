#!/usr/bin/env ruby1.9
# encoding: utf-8

require "rack"
require "rack/handler/thin"

app = eval("Rack::Builder.new {(\n#{File.read("config.ru")}\n)}.to_app")
Rack::Handler::Thin.run app, :Port => 4000
