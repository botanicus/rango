# coding=utf-8

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
        instance_variable_set("@#{name}", default_value.try_dup) # dup is terribly important, otherwise all the objects will points to one object. If it is for example array, all of the objects will push into one array.
      end
      instance_variable_get("@#{name}")
    end

    # define writer method
    define_method("#{name}=") do |value|
      instance_variable_set("@#{name}", value)
      # TODO: here should be rewritten the reader for cases when user want to do foo.bar = nil because now it will still returns the default value
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
        properties[name] = default_value.try_dup
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
  
  # class Post
  #   questionable :updated, true
  # end
  # Post.new.updated?
  # # => true
  # @since 0.0.2
  def questionable(name, default_value)
    define_method("#{name}?") do
      unless self.instance_variables.include?(name.to_sym)
        self.instance_variable_set("@#{name}", default_value)
      end
      self.instance_variable_get("@#{name}")
    end
  end
end
