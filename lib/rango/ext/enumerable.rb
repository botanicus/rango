# encoding: utf-8

module Enumerable
  # Enumerable#none? is the logical opposite of the builtin method Enumerable#any?. It
  # returns +true+ if and only if _none_ of the elements in the collection satisfy the
  # predicate.
  #
  # If no predicate is provided, Enumerable#none? returns +true+ if and only if _none_ of the
  # elements have a true value (i.e. not +nil+ or +false+).
  #
  # @author Botanicus
  # @from Extensions
  # @since 0.0.3
  # @yield [block] Block which will be evaluated in Project.setttings object.
  # @yieldparam [item] Each item of array-like collection
  # @yieldparam [key, value] Each item of hash-like collection
  # @option params [String, Array<String>] :exclude File or list of files or globs relative to base directory
  # @raise [LoadError] If base directory doesn't exist
  # @raise [ArgumentError] If first argument isn't a glob
  # @return [Array<String>] List of successfully loaded files
  # @example
  #   [].none?                      # => true
  #   [nil].none?                   # => true
  #   [5,8,9].none?                 # => false
  #   (1...10).none? { |n| n < 0 }  # => true
  #   (1...10).none? { |n| n > 0 }  # => false
  def none?(&block)
    not self.any?(&block)
  end
end
