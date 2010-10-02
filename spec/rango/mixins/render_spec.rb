# encoding: utf-8

require_relative "../../spec_helper"

require "rango/mixins/render"

Rango::Template.template_paths.clear.push(File.join(STUBS_ROOT, "templates"))

describe Rango::RenderMixin do
  it "should work standalone" do
    Rango::RenderMixin.should respond_to(:render)
  end

  it "should work as a mixin" do
    controller = Class.new { include Rango::RenderMixin }
    controller.new.should respond_to(:render)
  end

  describe "#render" do
    include Rango::RenderMixin
    it "should take a path as the first argument" do
      body = render "test.html"
      body.should be_kind_of(String)
    end

    it "should take a scope as the second argument" do
      context    = Object.new
      body       = render "context_id.html", context
      context_id = body.chomp.to_i
      context_id.should eql(context.object_id)
    end

    it "should take context as the third argument" do
      context = Object.new
      body    = render "index.html", context, title: "Hi!"
      body.should match(/Hi\!/)
    end

    it "should take the second arguments as a context if it's a hash and there is no third argument" do
      body = render "index.html", title: "Hi!"
      body.should match(/Hi\!/)
    end

    it "should raise TemplateInheritance::TemplateNotFound if template wasn't found" do
      -> { render "idonotexist.html" }.should raise_error(TemplateInheritance::TemplateNotFound)
    end
  end
end
