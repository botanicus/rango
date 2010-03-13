# encoding: utf-8

require "rango"
require "rango/controller"
require "rango/environments"
require "rango/mixins/rendering"
require "rango/mixins/message"
require "rango/mixins/filters"
require "rango/rack/middlewares/basic"

module Rango
  class StackController < Controller
    include ExplicitRendering
    include FiltersMixin
    include MessageMixin
  end
end
