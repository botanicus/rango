# encoding: utf-8

require "ostruct"
require "uri"
require "media-path"
require "rubyexts"

rango_lib = File.dirname(__FILE__)
unless $:.include?(rango_lib) || $:.include?(File.expand_path(rango_lib))
  $:.unshift(rango_lib)
end

# It should solve problems with encoding in URL (flash messages) and templates
Encoding.default_internal = "utf-8"

require_relative "rango/mixins/import"
require_relative "rango/mixins/application"

module Rango
  VERSION ||= "0.0.6"
  extend ImportMixin
  extend ApplicationMixin

  def self.root
    File.join(File.dirname(__FILE__), "rango")
  end

  # realoder
  # require "rango/reloader"
  # cattr_reader :reloader
  # @@reloader = Rango::Reloader.new
end

require_relative "rango/rango"
