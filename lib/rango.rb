# encoding: utf-8

require "ostruct"
require "uri"
require "path"

rango_lib = File.dirname(__FILE__)
unless $:.include?(rango_lib) || $:.include?(File.expand_path(rango_lib))
  $:.unshift(rango_lib)
end

# It should solve problems with encoding in URL (flash messages) and templates
Encoding.default_internal = "utf-8"

require_relative "rango/ext"
require_relative "rango/mixins/import"
require_relative "rango/mixins/application"
load File.dirname(__FILE__) + "/../rango.gemspec"

# FIXME
# require_relative "../rango.gemspec" # VERSION, CODENAME and SPECIFICATION

class Rango
  extend ImportMixin
  extend ApplicationMixin

  def self.root
    File.join(File.dirname(__FILE__), "rango")
  end
end

Rango.import("rango")
