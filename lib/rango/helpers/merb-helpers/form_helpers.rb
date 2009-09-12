# encoding: utf-8

require_relative "form/helpers"
require_relative "form/builder"

module Rango
  module Helpers
    include Rango::Helpers::Form
  end
end

class Rango::Controller
  class_inheritable_accessor :_default_builder
end

# Rango::BootLoader.after_app_loads do
#   module Rango::Controller
#     self._default_builder =
#       Object.full_const_get(Rango::Plugins.config[:helpers][:default_builder]) rescue Rango::Helpers::Form::Builder::ResourcefulFormWithErrors
#   end
# end
