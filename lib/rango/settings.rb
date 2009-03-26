class Rango
  class Settings
    def merge(another)
      self.__hattributes__.merge(another.__hattributes__)
    end

    def merge!(another)
      self.__hattributes__.merge!(another.__hattributes__)
    end

    # TODO: forwarding
    def [](name)
      self.__hattributes__[name]
    end

    def []=(name, value)
      self.__hattributes__[name] = value
    end

    def inspect
      self.__hattributes__.inspect
    end

    def method_missing(name, *args, &block)
      if name.to_s.match(/^([\w\d]+)=$/) && args.length.eql?(1)# && not block_given?
        Rango.logger.warn("Unknown setting item: #$1")
      end
    end

    class Framework < Settings
      hattribute :debug, true
      hattribute :router, lambda { Project.path.join("urls.rb") }
      hattribute :media_root, lambda { Project.path.join("media") }
      hattribute :template_dirs, lambda { [Project.path.join("templates")] }
      hattribute :database_path, lambda { "#{Rango.environment}.db" }
      hattribute :database_adapter, "sqlite3"
      hattribute :logger_strategy, "fireruby"
      hattribute :daemonize, false
    end
  end
end
