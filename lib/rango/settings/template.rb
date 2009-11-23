# encoding: utf-8

require "rango/settings"

module Rango
  module Settings
    class Template < Settings
      # @since 0.0.3
      hattribute :caching, Rango.development?

      # @since 0.0.3
      # useful for helpers
      hattribute :format, :html

      # @since 0.0.3
      hattribute :format_version, 5
    end
  end
end
