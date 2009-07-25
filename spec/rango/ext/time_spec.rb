# encoding: utf-8

require_relative "../../../lib/rango/ext/time"

describe Time do
  describe ".timer" do
    it "should returns how long it takes to run the block" do
      Time.timer { sleep 0.001 }.round(3).should eql(0.001)
    end
  end
end
