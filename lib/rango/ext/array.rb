# encoding: utf-8

class Array
  # Returns the _only_ element in the array.
  #
  # @author Botanicus
  # @from Extensions
  # @since 0.0.3
  # @raise [IndexError] If array hasn't exactly one element
  # @return [Object] First item of the array
  # @examples
  #   [5].only        # => 5
  #   [1, 2, 3].only  # => IndexError
  #   [].only         # => IndexError
  def only
    raise IndexError, "Array#only called on non-single-element array" unless self.size == 1
    self.first
  end
end
