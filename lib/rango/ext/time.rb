# encoding: utf-8

class Time
  # How long it takes to run the block in seconds
  #
  # @author Botanicus
  # @since 0.0.3
  # @return [Float] How long it takes to run the block in seconds
  # @examples
  #   Time.timer { sleep 2 } # => 2.030802
  def self.timer(&block)
    start = Time.now.tap { block.call }
    return Time.now - start
  end
end
