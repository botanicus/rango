# encoding: utf-8

class Object
  # stolen from rails (but our definition isn't compatible)
  # rails defines try as __send__ for each objects exclude nil - nil#try returns nil
  # our try returns nil if the method doesn't exist
  #
  # Invokes the method identified by the symbol +method+, passing it any arguments
  # and/or the block specified, just like the regular Ruby <tt>Object#send</tt> does.
  #
  # *Unlike* that method however, a +NoMethodError+ exception will *not* be raised
  # and +nil+ will be returned instead, if the receiving object is a +nil+ object or NilClass.
  #
  # @example
  #
  # Without try
  #   @person && @person.name
  # or
  #   @person ? @person.name : nil
  #
  # With try
  #   @person.try(:name)
  #
  # +try+ also accepts arguments and/or a block, for the method it is trying
  #   Person.try(:find, 1)
  #   @people.try(:collect) {|p| p.name}
  def try(method, *args, &block)
    self.send(method, *args, &block) if self.respond_to?(method)
  end

  # The opposite of <tt>#nil?</tt>.
  #
  #   "hello".not_nil?      # -> true
  #   nil.not_nil?          # -> false
  def not_nil?
    not self.nil?
  end

  # Defines a singleton method on the object.  For example, the following are
  # equivalent (assume <tt>o = Object.new</tt>):
  #
  #   def o.add(x, y)
  #     x + y
  #   end
  #
  #   o.define_method(:add) do |x, y|
  #     x + y
  #   end
  #
  # The difference is that with <tt>define_method</tt>, you can use variables
  # local to the _current_ scope.
  #
  #   x = 5
  #   o.define_method(:add_x) do |n|
  #     x + n
  #   end
  #   o.add_x(11)          # -> 16
  #
  # You can't define such a method as <tt>add_x</tt> above with <tt>def
  # o.add_x; x + n; end</tt>, as +def+ introduces a new scope.
  #
  # There are three ways to provide the body of the method: with a block (as
  # in both examples above), or with a +Proc+ or +Method+ object.  See the
  # built-in method <tt>Module#define_method</tt> for details.
  #
  # (This method is exactly equivalent to calling <tt>Module#define_method</tt>
  # in the scope of the singleton class of the object.)
  #
  def define_method(*args, &block)
    singleton_class = class << self; self; end
    singleton_class.module_eval do
      define_method(*args, &block)
    end
  end
end
