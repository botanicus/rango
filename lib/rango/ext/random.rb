# encoding: utf-8

class Array
  # @author Botanicus
  # @since 0.0.2
  # @return [Object] Random item from array
  def rand
    self[Kernel.rand(length)]
  end
  alias_method :random, :rand
end

class Range
  # @author Botanicus
  # @since 0.0.2
  # @return [Object] Random item from range
  def rand
    self.min + Kernel.rand(self.max)
  end
  alias_method :random, :rand
end
