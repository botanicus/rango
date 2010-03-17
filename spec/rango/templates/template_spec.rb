# encoding: utf-8

require_relative "../../spec_helper"
require "rango/templates/template"

Rango::Template.template_paths.clear.push(File.join(STUBS_ROOT, "templates"))

describe Rango::Template do
  describe "#initialize" do
    it "should take path as a first argument" do
      template = Rango::Template.new("test.html")
      template.path.should eql("test.html")
    end

    it "should take scope as an optional second argument" do
      scope  = Object.new
      template = Rango::Template.new("test.html", scope)
      template.scope.should eql(scope)
    end
  end

  describe "#fullpath" do
    it "should find" do
      template = Rango::Template.new("test.html")
      fullpath = File.join(STUBS_ROOT, "templates", "test.html.haml")
      template.fullpath.should eql(fullpath)
    end
  end

  describe "#render" do
    it "should raise TemplateNotFound if template can't be found" do
      template = Rango::Template.new("idonotexist.html")
      -> { template.render }.should raise_error(Rango::Exceptions::TemplateNotFound)
    end

    it "should render" do
      template = Rango::Template.new("test.html")
      template.render.should eql("<html></html>\n")
    end

    it "should have template inheritance" do
      template = Rango::Template.new("inheritance/basic/index.html")
    end

    it "should capture haml" do
      template = Rango::Template.new("inheritance/capture/haml/index.html")
      template.render
      template.blocks[:content].should match("Hello!")
    end
  end

  describe "variables" do
    before(:each) do
      @template = Rango::Template.new("variables.html")
    end

    it "should capture erb" do
      # @template.render(title: "Hi!").should match("Hi!")
    end
  end
end
