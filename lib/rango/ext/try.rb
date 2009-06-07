# encoding: utf-8

# stolen from rails (but our definition isn't compatible)
# rails defines try as __send__ for each objects exclude nil - nil#try returns nil
# our try returns nil if the method doesn't exist

class Object
  # Invokes the method identified by the symbol +method+, passing it any arguments
  # and/or the block specified, just like the regular Ruby <tt>Object#send</tt> does.
  #
  # *Unlike* that method however, a +NoMethodError+ exception will *not* be raised
  # and +nil+ will be returned instead, if the receiving object is a +nil+ object or NilClass.
  #
  # ==== Examples
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
end
