# coding: utf-8

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
    def to_hash
      self.__hattributes__
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

      # @since 0.0.2
      hattribute :mime_formats, Array.new
      
      # @since 0.0.2
      hattribute :autoescape, true
      
      # @since 0.0.2
      # Project.settings.haml.format
      hattribute :erubis, Erubis.new
      
      # @since 0.0.2
      # Project.settings.erubis.pattern
      hattribute :haml, Haml.new
    end
    
    class Erubis
      # @since 0.0.2
      hattribute :pattern, "<% %>" # can be string or regexp

      # @since 0.0.2
      # hattribute :erubis_class, "fooo" # use your own class instead of Erubis::Eruby. Don't forget that you must include (TODO: what) for autoescaping
    end
    
    class Haml
      # @since 0.0.2
      # Determines the output format. The default is :xhtml. Other options are :html4 and :html5, which are identical to :xhtml except there are no self-closing tags, XML prolog is ignored and correct DOCTYPEs are generated. 
      hattribute :format, :xhtml
      
      # @since 0.0.2
      # Sets whether or not to escape HTML-sensitive characters in script. If this is true, = behaves like &=; otherwise, it behaves like !=. Note that if this is set, != should be used for yielding to subtemplates and rendering partials. Defaults to false. 
      hattribute :escape_html, Project.settings.autoescape
      
      # @since 0.0.2
      # Whether or not attribute hashes and Ruby scripts designated by =  or ~ should be evaluated. If this is true, said scripts are rendered as empty strings. Defaults to false. 
      hattribute :suppress_eval, false
      
      # @since 0.0.2
      # The character that should wrap element attributes. This defaults to ' (an apostrophe). Characters of this type within the attributes will be escaped (e.g. by replacing them with &apos;) if the character is an apostrophe or a quotation mark.
      hattribute :attr_wrapper, '"'
      
      # @since 0.0.2
      # A list of tag names that should be automatically self-closed if they have no content. Defaults to ['meta', 'img', 'link', 'br', 'hr', 'input', 'area', 'param', 'col', 'base']. 
      hattribute :autoclose, %w[meta img link br hr input area param col base]
      
      # @since 0.0.2
      # A list of tag names that should automatically have their newlines preserved using the Haml::Helpers#preserve  helper. This means that any content given on the same line as the tag will be preserved. For example
      # %textarea= "Foo\nBar"
      # compiles to: 
      # <textarea>Foo&&#x000A;Bar</textarea>
      # Defaults to ['textarea', 'pre']. 
      hattribute :preserve, %w[textarea pre]
    end
  end
end
