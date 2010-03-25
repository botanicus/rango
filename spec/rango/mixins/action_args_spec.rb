# encoding: utf-8

require_relative "../../spec_helper"

require "rango/controller"
require "rango/mixins/action_args"

Rango::Router.use(:urlmap)

describe Rango::ActionArgsMixin do
  controller = Class.new(Rango::Controller) do
    include Rango::ActionArgsMixin

    def show(id)
      id
    end

    def create(post, msg = "Created successfuly")
      "#{post} - #{msg}"
    end

    def view_with_a_splat(id, *args)
      id
    end

    def view_with_a_block(id, &block)
      id
    end
  end

  def env_for_action(action, url = "/")
    env = Rack::MockRequest.env_for(url)
    env.merge("rango.controller.action" => action)
  end

  it "should ignore splat arguments" do
    env = env_for_action(:view_with_a_splat, "/?id=12")
    status, headers, body = controller.call(env)
    body.should eql(["12"])
  end

  it "should ignore block arguments" do
    env = env_for_action(:view_with_a_block, "/?id=12")
    status, headers, body = controller.call(env)
    body.should eql(["12"])
  end

  it "should raise argument error if there are arguments which doesn't match any key in params" do
    env = env_for_action(:show)
    -> { controller.call(env) }.should raise_error(ArgumentError)
  end

  it "should call a view with arguments matching params[argument]" do
    env = env_for_action(:show, "/?id=12")
    status, headers, body = controller.call(env)
    body.should eql(["12"])
  end

  it "should call a view with arguments matching params[argument]" do
    env = env_for_action(:show, "/?id=12&msg=hi") # nevadi ze je tam toho vic
    status, headers, body = controller.call(env)
    body.should eql(["12"])
  end

# NOTE: we can't use stubs because the stub redefine the method, so parameters of this method will be everytime just optional args and block
  it "should call a view with arguments matching params[argument]" do
    env = env_for_action(:create, "/?post=neco&msg=message")
    status, headers, body = controller.call(env)
    body.should eql(["neco - message"])
  end

  it "should not require optinal arguments to be in params" do
    env = env_for_action(:create, "/?post=neco")
    status, headers, body = controller.call(env)
    body.should eql(["neco - Created successfuly"])
  end
end
