# encoding: utf-8

require "rango/settings"

module Rango
  module Settings
    class Framework < Settings
      # @since 0.0.1
      # @return [Boolean] explanation
      hattribute :debug, true

      # @since 0.0.1
      # @return [String] Path to your +media+ directory.
      hattribute :media_root, lambda { File.join(Project.root, "media") }

      # @since 0.0.2
      # @return [String] rango-project.org/media/javascripts/mootools-core.js
      hattribute :media_prefix,  String.new#"/media"

      # @since 0.0.1
      # @return [Array[String]] Array with paths where Rango will trying to find templates.
      hattribute :template_dirs, ["templates"]

      # @since 0.0.1
      # @return [String] Name of your database or path to the database if you are using SQLite3.
      hattribute :database_name, lambda { "#{Rango.environment}.db" }

      # @since 0.0.2
      # @return [String] Array of emails.
      hattribute :admins, Array.new

      # @since 0.0.1
      # @return [String] Database adapter.
      hattribute :database_adapter, "sqlite3"

      # @since 0.0.1
      # @return [String] explanation
      # hattribute :logger_strategy, "fireruby"

      # @since 0.0.1
      # @return [Boolean] ORM. Can be datamapper or nil.
      hattribute :orm

      # @since 0.0.1
      # @return [Boolean] Template engine. Can be haml, erb, erubis or nil (so just plain html will be returned).
      hattribute :template_engine, "haml"

      # @since 0.0.1
      # @return [Boolean] Testing engine. Can be rspec or nil.
      hattribute :testing_engine

      # @since 0.0.1
      # @return [Boolean] Features engine. Can be cucumber or nil.
      hattribute :features_engine

      # @since 0.0.2
      hattribute :mime_formats, Array.new

      # @since 0.0.2
      hattribute :autoescape, true

      # @since 0.0.2
      hattribute :gems_directory, lambda { File.join(Project.root, "gems") }

      # @since 0.0.2
      hattribute :sources_directory, lambda { File.join(Project.root, "sources") }

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
