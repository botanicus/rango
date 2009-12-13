# encoding: utf-8

require_relative "../../spec_helper"
require "rango/templates/template"
require "rubyexts/string" # TODO: remove this after rubyexts update

Project.settings.template_dirs = [File.join(STUBS_ROOT, "templates")]

describe Rango::Template do
  describe "#initialize" do
    it "should take path as a first argument" do
      template = Rango::Template.new("test.html")
      template.path.should eql("test.html")
    end

    it "should take context as an optional second argument" do
      context  = Object.new
      template = Rango::Template.new("test.html", context)
      template.context.should eql(context)
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
      -> { template.render }.should raise_error(Rango::Errors::TemplateNotFound)
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

    it "should capture erubis" do
      template = Rango::Template.new("inheritance/capture/erubis/index.html")
      template.render
      template.blocks[:content].should match("Hello!")
    end

    it "should capture erb" do
      pending "ERB or ERB adapter in Tilt seems to have problems with capturing"
      template = Rango::Template.new("inheritance/capture/erb/index.html")
      template.render
      template.blocks[:content].should match("Hello!")
    end
  end
  
  describe "variables" do
    before(:each) do
      @template = Rango::Template.new("variables.html")
    end

    it "should capture erb" do
      @template.render(title: "Hi!").should match("Hi!")
    end
    
    it "should <%= &block %>" do
      pending "<%= &block %> should works for Erubis"
      template = Rango::Template.new("erubis.html")
      puts template.render
    end
  end
end
