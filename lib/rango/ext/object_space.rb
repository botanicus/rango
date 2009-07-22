# encoding: utf-8

# TODO: ObjectSpace.modules don't work
# TODO: figure out what each_object(some_module) do
# TODO: isn't it already in extlib?

module ObjectSpace
  # @author Botanicus
  # @since 0.0.3
  # @return [Array<Class>] List of all classes loaded into runtime
  def self.classes
    self.all(Class)
  end

  # @author Botanicus
  # @since 0.0.3
  # @return [Array<Module>] List of all modules loaded into runtime
  def self.modules
    self.all(Module)
  end

  # @author Botanicus
  # @since 0.0.3
  # @param [Class, Module]
  # @example Get all numbers
  #   ObjectSpace.all(Numeric) # => [1, 0.3, ...]
  # @example Get all numbers
  #   ObjectSpace.all(Numeric) # => [1, 0.3, ...]
  # @return [Array] List of all objects of given class or list of all objects
  def self.all(klass)
    Array.new.tap do |objects|
      self.each_object(klass) do |object|
        objects << object
      end
    end
  end
end
