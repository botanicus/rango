# encoding: utf-8

class Object
  # *Unlike* that method however, a +NoMethodError+ exception will *not* be raised
  # and +nil+ will be returned instead, if the receiving object is a +nil+ object or NilClass.
  #
  # Invokes the method identified by the symbol +method+, passing it any arguments
  # and/or the block specified, just like the regular Ruby <tt>Object#send</tt> does.
  #
  # @author Botanicus
  # @since 0.0.3
  # @return [Object, nil] Return value of object.send(method) if object respond to method or nil
  # @param [Symbol] Method which will be called on object if object respond to this method
  # @param [Object, optional] Arguments for +method+ argument
  # @yield [block, optional] Block for +method+ argument
  # @example
  #   @post.try(:name) # instead @post && @post.name
  #   eBook.try(:find, 1)
  #   @post.try(:collect) { |p| p.name }
  def try(method, *args, &block)
    self.send(method, *args, &block) if self.respond_to?(method)
  end

  # The opposite of <tt>#nil?</tt>.
  #
  # @author Botanicus
  # @since 0.0.3
  # @return [true, false] True if self is nil, false otherwise
  def not_nil?
    not self.nil?
  end

  # Defines a instance method on class of the object.
  # 
  # @author Botanicus
  # @since 0.0.3
  # @param [Symbol] Method name
  # @param [Method, Proc, optional] +Method+ or +Proc+ which will be used as body of the method
  # @yield [block] Block which will be used as body of the method
  # @return [Object] First (and only) item of the array
  # @see <tt>Module#define_singleton_method</tt> for define method on singleton class
  # @example
  #   class Experiment
  #     def method_generator
  #       define_instance_method(:new_method) do |arg|
  #         puts "Method :new_method called with #{arg}"
  #       end
  #     end
  #   end
  #   Experiment.new.methods.include?(:new_method) # => false
  #   Experiment.new.method_generator
  #   Experiment.new.methods.include?(:new_method) # => true
  def define_instance_method(*args, &block)
    self.class.send(:define_method, *args, &block)
  end
end
