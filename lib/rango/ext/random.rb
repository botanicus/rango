# encoding: utf-8

class Array
  def rand
    self[Kernel.rand(length)]
  end
  alias_method :random, :rand
end

class Range
  def rand
    self.min + Kernel.rand(self.max)
  end
  alias_method :random, :rand
end

class Hash
  def rand
    self[self.keys.random]
  end
  alias_method :random, :rand
end
