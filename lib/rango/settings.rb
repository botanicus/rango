# coding=utf-8

class Rango
  class Settings
    # @since 0.0.1
    # @example
    #   Project.settings.merge(MyPlugin.settings)
    # @param [Rango::Settings] another Settings which will be merged into self. It doesn't change self.
    # @return [Hash] Hash of settings attributes.
    # TODO: maybe it should returns Rango::Settings?
    def merge(another)
      self.__hattributes__.merge(another.__hattributes__)
    end

    # @since 0.0.1
    # @example
    #   Project.settings.merge!(MyPlugin.settings)
    # @param [Rango::Settings] another Settings which will be merged into self. It change self.
    # @return [Hash] Hash of settings attributes.
    # TODO: maybe it should returns Rango::Settings?
    def merge!(another)
      self.__hattributes__.merge!(another.__hattributes__)
    end

    # @since 0.0.1
    # @example
    # @return [String] All settings attributes in inspect format.
    def inspect
      self.__hattributes__.inspect
    end

    # @since 0.0.1
    # @example
    #   Project.configure do
    #     self.foobar = "something"
    #   end
    #   # => Logger will warn you that property foobar doesn't exist.
    # @param [type] name explanation
    def method_missing(name, *args, &block)
      if name.to_s.match(/^([\w\d]+)=$/) && args.length.eql?(1)# && not block_given?
        Rango.logger.warn("Unknown setting item: #$1")
      end
    end

    class Framework < Settings
      # @since 0.0.1
      # @return [Boolean] explanation
      hattribute :debug, true

      # @since 0.0.1
      # @return [Boolean] Path to your router. Default +urls.rb+.
      hattribute :router, "urls.rb"

      # @since 0.0.1
      # @return [String] Path to your +media+ directory.
      hattribute :media_root, ["media"]

      # @since 0.0.1
      # @return [Array[String]] Array with paths where Rango will trying to find templates.
      hattribute :template_dirs, ["templates"]

      # @since 0.0.1
      # @return [String] Name of your database or path to the database if you are using SQLite3.
      hattribute :database_name, lambda { "#{Rango.environment}.db" }

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

      hattribute :mime_formats, Array.new
    end
  end
end
