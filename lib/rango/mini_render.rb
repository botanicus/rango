# encoding: utf-8

# Rango::Mini is the most low-level part which can render
# templates standalone. More low-level is only the RenderMixin.
# See http://wiki.github.com/botanicus/rango/template-rendering

require "rango/mini"
require "rango/mixins/render"

module Rango
  module MiniRender
    include Rango::Mini
    include Rango::RenderMixin
    extend self # so you can run Rango::MiniRender.app
  end
end
