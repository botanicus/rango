# encoding: utf-8

require_relative "../../../lib/rango/ext/object"

class ObjectStub
  def generator
    define_instance_method(:new_method) { "return value" }
  end

  def proxy(*args, &block)
    return {args: args, block: block}
  end
end

describe Object do
  before(:each) do
    @stub = ObjectStub.new
  end

  describe "#try" do
    it "should returns nil if given method doesn't exist" do
      @stub.try(:a_method).should be_nil
    end

    it "can takes arguments" do
      returned = @stub.try(:proxy, :one, :two, :three)
      returned[:args].should eql([:one, :two, :three])
    end

    it "can takes block" do
      returned = @stub.try(:proxy) { [:one, :two, :three] }
      returned[:block].call.should eql([:one, :two, :three])
    end
  end

  describe "#not_nil?" do
    it "should be true if object isn't nil" do
      Object.new.not_nil?.should be_true
    end

    it "should be false if object is nil" do
      nil.not_nil?.should be_false
    end
  end

  describe "#define_instance_method" do
    before(:each) do
      @stub = ObjectStub.new
    end

    it "should define instance method" do
      @stub.generator
      methods = ObjectStub.instance_methods
      methods.should include(:new_method)
    end
  end
end
