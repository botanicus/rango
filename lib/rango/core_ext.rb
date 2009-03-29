# coding=utf-8

# TODO: spec it
require File.join(File.dirname(__FILE__), "path")

module Kernel
  # @since 0.0.1
  # @example
  #   try_require "term/ansicolor", "term-ansicolor"
  # @param [String] library Library to require.
  # @param [String, @optional] gemname Name of gem which contains required library. Will be used for displaying message.
  # @return [Boolean] True if require was successful, false otherwise.
  def try_require(library, gemname = library)
    begin
      require library
    rescue LoadError
      message = "Gem #{gemname} isn't installed. Run sudo gem install #{gemname}."
      if defined?(Rango.logger)
        Rango.logger.warn(message)
        return false
      else
        puts(message)
        return false
      end
    end
  end
end

try_require "term/ansicolor", "term-ansicolor"
class String
  # @since 0.0.1
  # @example
  #   "message".colorize.red.colorize.bold
  # @param [type] name explanation
  # @return [String] Return duplication of self. In it's metaclass is included +Term::ANSIColor+.
  def colorize
    return self unless defined?(Term)
    message = self.dup # otherwise it can try to modify frozen string
    class << message
      include Term::ANSIColor
    end
    return message
  end
  
  # rack
  alias_method :each, :each_line
end

# default value for attr
class Class
  # @since 0.0.1
  # @example
  #   class Post
  #     attribute :title, "Rango rulez!"
  #   end
  # Post.new.title
  # # => "Rango rulez!"
  # @param [Symbol] name Name of object variable which will be set. If you have <tt>attribute :title</tt>, then the +@title+ variable will be defined. It also create +#title+ and +#title=+ accessors.
  # @param [Object, @optional] default_value Default value of the variable.
  # @return [name] Returns given default value or if default value.
  # @see #hattribute
  def attribute(name, default_value = nil)
    # define reader method
    define_method(name) do
      if instance_variable_get("@#{name}").nil?
        # lazy loading
        # TODO: why is it lazy loaded?
        default_value = default_value.call if default_value.is_a?(Proc)
        instance_variable_set("@#{name}", default_value)
      end
      instance_variable_get("@#{name}")
    end

    # define writer method
    define_method("#{name}=") do |value|
      instance_variable_set("@#{name}", value)
    end

    return default_value
  end

  # This will also define title and title= methods, but it doesn't define @title variable,
  # but @__hattributes__ hash with all the attributes
  
  # @since 0.0.1
  # @example
  #   class Post
  #     hattribute :title, "Rango rulez!"
  #   end
  #   Post.new.title
  #   # => "Rango rulez!"
  # @param [Symbol] name Name of attribute his accessor methods will be defined. It's similar as +#attribute+, but it doesn't define +@name+ variable, but it will be key in +@__hattributes__+ hash. It's useful when you don't like to mess the object namespace with many variables or if you like to separate the attributes from the instance variables.
  # @param [Object, @optional] default_value Default value of the variable.
  # @return [name] Returns given default value or if default value.
  # @see #attribute
  def hattribute(name, default_value = nil)
    # define reader method
    define_method(name) do
      properties = instance_variable_get("@__hattributes__") || Hash.new
      if properties[name].nil?
        # instance_variable_set("@#{name}", default_value)
        # lazy loading
        default_value = default_value.call if default_value.is_a?(Proc)
        properties[name] = default_value
      end
      # instance_variable_get("@#{name}")
      properties[name]
    end

    # define writer method
    define_method("#{name}=") do |value|
      # each object will have __hattributes__ method
      unless self.respond_to?(:__hattributes__)
        self.class.attribute :__hattributes__, Hash.new
      end
      instance_variable_set("@__hattributes__", Hash.new) unless instance_variable_get("@__hattributes__")
      instance_variable_get("@__hattributes__")[name] = value
    end

    return default_value
  end
end
