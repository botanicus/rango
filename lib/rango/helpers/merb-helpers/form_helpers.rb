# encoding: utf-8

load File.dirname(__FILE__) / "form" / "helpers.rb"
load File.dirname(__FILE__) / "form" / "builder.rb"

module Rango::Helpers
  include Rango::Helpers::Form
end

class Rango::Controller
  class_inheritable_accessor :_default_builder
end

# Rango::BootLoader.after_app_loads do
#   class Rango::Controller
#     self._default_builder =
#       Object.full_const_get(Rango::Plugins.config[:helpers][:default_builder]) rescue Rango::Helpers::Form::Builder::ResourcefulFormWithErrors
#   end
# end
