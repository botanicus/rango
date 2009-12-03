# encoding: utf-8

# Generic Views
# Use directly or include into a controller if you want to use filters or customize them
# http://wiki.github.com/botanicus/rango/generic-views

require "rango/mini"
require "rango/router"
require "rango/mixins/render"

module Rango
  module GV
    extend Rango::RenderMixin
  end
end
