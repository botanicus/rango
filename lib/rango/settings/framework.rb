# encoding: utf-8

require "rango/settings"

module Rango
  module Settings
    class Framework < Settings
      # @since 0.0.1
      # @return [String] Path to your +media+ directory.
      hattribute :media_root, lambda { File.join(Project.root, "media") }

      # @since 0.0.2
      # @return [String] rango-project.org/media/javascripts/mootools-core.js
      hattribute :media_prefix,  String.new#"/media"

      # @since 0.0.1
      # @return [Array[String]] Array with paths where Rango will trying to find templates.
      hattribute :template_dirs, ["templates"]

      # @since 0.0.2
      hattribute :mime_formats, Array.new

      # @since 0.0.2
      # Project.settings.erubis.pattern
      # hattribute :erubis, lambda { self.settings_module(:erubis) }
      def erubis
        self.settings_module(:erubis)
      end

      # @since 0.0.2
      # Project.settings.haml.format
      # hattribute :haml, lambda { self.settings_module(:haml) }
      def haml
        self.settings_module(:haml)
      end
    end
  end
end
