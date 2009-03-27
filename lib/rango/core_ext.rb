require File.join(File.dirname(__FILE__), "path")

module Kernel
  def try_require(library, gemname)
    begin
      require library
    rescue LoadError
      message = "Gem #{gemname} isn't installed. Run sudo gem install #{gemname}."
      if defined?(Rango.logger)
        Rango.logger.warn(message)
      else
        puts(message)
      end
    end
  end
end

try_require "term/ansicolor", "term-ansicolor"
class String
  def colorize
    return self unless defined?(Term)
    message = self.dup # otherwise it can try to modify frozen string
    class << message
      include Term::ANSIColor
    end
    return message
  end
end

# default value for attr
class Class
  # class Post
  #   attribute :title, "Rango rulez!"
  # end
  # This will define @title variable plus title and title= methods
  # Post.new.title
  # => "Rango rulez!"
  def attribute(name, default_value = nil)
    # define reader method
    define_method(name) do
      if instance_variable_get("@#{name}").nil?
        # lazy loading
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

  # class Post
  #   hattribute :title, "Rango rulez!"
  # end
  # This will also define title and title= methods, but it doesn't define @title variable,
  # but @__hattributes__ hash with all the attributes
  # Post.new.title
  # => "Rango rulez!"
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
