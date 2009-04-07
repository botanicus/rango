require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe "Rango::Authentication::Strategy" do

  before(:all) do
    clear_strategies!
  end

  before(:each) do
    clear_strategies!
  end

  after(:all) do
    clear_strategies!
  end

  describe "adding a strategy" do
    it "should add a strategy" do
      class MyStrategy < Rango::Authentication::Strategy; end
      Rango::Authentication.strategies.should include(MyStrategy)
    end

    it "should keep track of the strategies" do
      class Sone < Rango::Authentication::Strategy; end
      class Stwo < Rango::Authentication::Strategy; end
      Rango::Authentication.strategies.should include(Sone, Stwo)
      Rango::Authentication.default_strategy_order.pop
      Rango::Authentication.strategies.should include(Sone, Stwo)
    end

    it "should add multiple strategies in order of decleration" do
      class Sone < Rango::Authentication::Strategy; end
      class Stwo < Rango::Authentication::Strategy; end
      Rango::Authentication.default_strategy_order.should == [Sone, Stwo]
    end

    it "should allow a strategy to be inserted _before_ another strategy in the default order" do
      class Sone < Rango::Authentication::Strategy; end
      class Stwo < Rango::Authentication::Strategy; end
      class AuthIntruder < Rango::Authentication::Strategy; before Stwo; end
      Rango::Authentication.strategies.should include(AuthIntruder, Stwo, Sone)
      Rango::Authentication.default_strategy_order.should == [Sone, AuthIntruder, Stwo]
    end

    it "should allow a strategy to be inserted _after_ another strategy in the default order" do
      class Sone < Rango::Authentication::Strategy; end
      class Stwo < Rango::Authentication::Strategy; end
      class AuthIntruder < Rango::Authentication::Strategy; after Sone; end
      Rango::Authentication.strategies.should include(AuthIntruder, Stwo, Sone)
      Rango::Authentication.default_strategy_order.should == [Sone, AuthIntruder, Stwo]
    end
  end

  describe "the default order" do
    it "should allow a user to overwrite the default order" do
      class Sone < Rango::Authentication::Strategy; end
      class Stwo < Rango::Authentication::Strategy; end
      Rango::Authentication.default_strategy_order = [Stwo]
      Rango::Authentication.default_strategy_order.should == [Stwo]
    end

    it "should get raise an error if any strategy is not an Rango::Authentication::Strategy" do
      class Sone < Rango::Authentication::Strategy; end
      class Stwo < Rango::Authentication::Strategy; end
      lambda do
        Rango::Authentication.default_strategy_order = [Stwo, String]
      end.should raise_error(ArgumentError)
    end
  end

  it "should raise a not implemented error if the run! method is not defined in the subclass" do
    class Sone < Rango::Authentication::Strategy; end
    lambda do
      request = fake_request
      Sone.new(request, request.params).run!
    end.should raise_error(Rango::Authentication::NotImplemented)
  end

  it "should not raise an implemented error if the run! method is defined on the subclass" do
    class Sone < Rango::Authentication::Strategy; def run!; end; end
    lambda do
      Sone.new("controller").run!
    end.should_not raise_error(Rango::Authentication::NotImplemented)
  end

  describe "convinience methods" do

    before(:each) do
      class Sone < Rango::Authentication::Strategy; def run!; end; end
      @request = fake_request
      @strategy = Sone.new(@request, {:params => true})
    end

    it "should provide a params helper that defers to the controller" do
      @strategy.params.should == {:params => true }
    end

    it "should provide a cookies helper" do
      @request.should_receive(:cookies).and_return("COOKIES")
      @strategy.cookies.should == "COOKIES"
    end

  end

  describe "#user_class" do

    # This allows you to scope a particular strategy to a particular user class object
    # By inheriting you can add multiple user types to the authentication process

    before(:each) do
      class Sone < Rango::Authentication::Strategy; def run!; end; end
      class Stwo < Sone; end

      class Mone < Rango::Authentication::Strategy
        def user_class; String; end
        def run!; end
      end
      class Mtwo < Mone; end

      class Pone < Rango::Authentication::Strategy
        abstract!
        def user_class; Hash; end
        def special_method; true end
      end
      class Ptwo < Pone; end;

      @request = fake_request
    end

    it "should allow being set to an abstract strategy" do
      Pone.abstract?.should be_true
    end

    it "should not set the child class of an abstract class to be abstract" do
      Ptwo.abstract?.should be_false
    end

    it "should implement a user_class helper" do
      s = Sone.new(@request, @request.params)
      s.user_class.should == User
    end

    it "should make it into the strategies collection when subclassed from a subclass" do
      Rango::Authentication.strategies.should include(Mtwo)
    end

    it "should make it in the default_strategy_order when subclassed from a subclass" do
      Rango::Authentication.default_strategy_order.should include(Mtwo)
    end

    it "should defer to the Rango::Authentication.user_class if not over written" do
      Rango::Authentication.should_receive(:user_class).and_return(User)
      s = Sone.new(@request, @request.params)
      s.user_class
    end

    it "should inherit the user class from it's parent by default" do
      Rango::Authentication.should_receive(:user_class).and_return(User)
      s = Stwo.new(@request, @request.params)
      s.user_class.should == User
    end

    it "should inherit the user_class form it's parent when the parent defines a new one" do
      Rango::Authentication.should_not_receive(:user_class)
      m = Mtwo.new(@request, @request.params)
      m.user_class.should == String
    end

  end

  describe "#redirect!" do

    before(:all) do
      class FooController < Rango::Controller
        def index; "FooController#index" end
      end
    end

    before(:each) do
      class MyStrategy < Rango::Authentication::Strategy
        def run!
          if params[:url]
            params[:status] ? redirect!(params[:url], :status => params[:status]) : redirect!(params[:url])
          else
            "WINNA"
          end
        end
      end # MyStrategy

      Rango::Router.reset!
      Rango::Router.prepare{ match("/").to(:controller => "foo_controller")}
      @request = fake_request
      @s = MyStrategy.new(@request, @request.params)
    end

    it "allow for a redirect!" do
      @s.redirect!("/somewhere")
      @s.headers["Location"].should == "/somewhere"
    end

    it "should provide access to setting the headers" do
      @s.headers["Location"] = "/a/url"
      @s.headers["Location"].should == "/a/url"
    end

    it "should allow access to the setting header" do
      @s.status = 403
      @s.status.should == 403
    end

    it "should return nil for the Location if it is not redirected" do
      @s.should_not be_redirected
      @s.headers["Location"].should be_nil
    end

    it "should pass through the options to the redirect options" do
      @s.redirect!("/somewhere", :status => 401)
      @s.headers["Location"].should == "/somewhere"
      @s.status.should == 401
    end

    it "should set a redirect with a permanent true" do
      @s.redirect!("/somewhere", :permanent => true)
      @s.status.should == 301
    end

    it "should be redirected?" do
      @s.should_not be_redirected
      @s.redirect!("/somewhere")
      @s.should be_redirected
    end

    it "should set the strategy to halted" do
      @s.redirect!("/somewhere")
      @s.should be_halted
    end

    it "should halt a strategy" do
      @s.should_not be_halted
      @s.halt!
      @s.should be_halted
    end

    it "should allow a body to be set" do
      @s.body = "body"
      @s.body.should == "body"
    end

  end

  describe "register strategies" do

    it "should allow for a strategy to be registered" do
      Rango::Authentication.register(:test_one, "/path/to/strategy")
      Rango::Authentication.registered_strategies[:test_one].should == "/path/to/strategy"
    end

    it "should activate a strategy" do
      Rango::Authentication.register(:test_activation, File.expand_path(File.dirname(__FILE__)) / "activation_fixture")
      defined?(TheActivationTest).should be_nil
      Rango::Authentication.activate!(:test_activation)
      defined?(TheActivationTest).should_not be_nil
    end

    it "should raise if the strategy is not registered" do
      lambda do
        Rango::Authentication.activate!(:not_here)
      end.should raise_error
    end


  end

end
