# coding: utf-8

# It should solve problems with encoding in URL (flash messages) and templates
Encoding.default_internal = "utf-8"
require_relative "rango/ext"
require_relative "rango/mixins/import"
require_relative "rango/mixins/constant"

class Rango
  extend ImportMixin
  extend ConstantMixin
  
  def self.root
    File.join(File.dirname(__FILE__), "rango")
  end
end

Rango.import("rango")
