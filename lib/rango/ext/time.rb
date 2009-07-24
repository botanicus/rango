# encoding: utf-8

class Time
  # Time.timer { sleep 2 }
  # => 2.030802
  def self.timer(&block)
    start = Time.now
    block.call
    stop  = Time.now
    return stop - start
  end
end
