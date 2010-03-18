# encoding: utf-8

require_relative "../../spec_helper"
require "rango/templates/helpers"

Rango::Template.template_paths.clear.push(File.join(STUBS_ROOT, "templates"))

describe Rango::TemplateHelpers do
  include Rango::TemplateHelpers
  describe "#partial" do
    it "should work" do
      pending "This can't work because self.template doesn't exist, we have to use render mixin"
      partial "basic.html"
    end

    it "should share context with the parent template" do
      pending
    end

    it "should be able to specify additional context which isn't propagated to the parent template" do
      pending
    end
  end

  describe "#render" do
    it "should consider 'path.html' as a path relative to Template.template_paths" do
      pending
    end

    it "should consider './path.html' as a path relative to the current template" do
      pending
    end

    it "should look for '../path.html' in the parent directory of directory with current template" do
      pending
    end
  end

  describe "#includes" do
    require "rango/mixins/render"
    it "should return true" do
      Rango::RenderMixin.render("includes/basic.html").strip.should eql("true")
    end

    it "should work with blocks" do
      Rango::RenderMixin.render("includes/includes.html")
    end

    it "should work with extends" do
      output = Rango::RenderMixin.render("includes/integration.html")
      output.strip.should eql("Greeting by Jakub Stastny")
    end

    it "should work with extends" do
      output = Rango::RenderMixin.render("includes/integration2.html")
      output.strip.should eql("Greeting by Jakub Stastny")
    end
  end

  describe "extends" do
  end

  describe "block" do
    it "should raise argument error if name isn't specified" do
      -> { block(nil) }.should raise_error(ArgumentError)
    end

    it "should work as a setter if a value is provided" do
      output = Rango::RenderMixin.render("block/value.html")
      output.strip.should eql("a value")
    end

    it "should work as a setter if a block is provided" do
      output = Rango::RenderMixin.render("block/block.html")
      output.strip.should eql("a block")
    end

    it "should work as a getter" do
      output = Rango::RenderMixin.render("block/getter.html")
      output.strip.should eql("Hello World!")
    end

    it "should raise argument error if both value and block is provided" do
      -> { Rango::RenderMixin.render("block/error.html") }.should raise_error(ArgumentError)
    end

    it "should store the first non-nil value" do
      output = Rango::RenderMixin.render("block/blocks.html")
      output.strip.should eql("first")
    end
  end

  describe "extend_block" do
    it "should raise argument error if name isn't specified" do
      -> { Rango::RenderMixin.render("extend_block/name_error.html") }.should raise_error(NameError)
    end

    it "should raise argument error if both value and block is provided" do
      -> { Rango::RenderMixin.render("extend_block/error.html") }.should raise_error(ArgumentError)
    end

    it "should raise argument error if block of given name doesn't exist so far" do
      -> { Rango::RenderMixin.render("extend_block/error2.html") }.should raise_error
    end

    it "should work with super()-like inheritance" do
      Rango::RenderMixin.render("extend_block/basic.html")
    end

    it "should do nothing if the value or block is nil" do
      output = Rango::RenderMixin.render("extend_block/nil.html")
      output.strip.should eql("Original")
    end
  end

  describe "enhance_block" do
    it "should work even if the block isn't defined so far" do
      output = Rango::RenderMixin.render("enhance_block/standalone.html")
      output.strip.should eql("Hello World!")
    end

    it "should not raise argument error if name isn't specified" do
      -> { Rango::RenderMixin.render("enhance_block/name_error.html") }.should_not raise_error(NameError)
    end

    it "should raise argument error if both value and block is provided" do
      -> { Rango::RenderMixin.render("enhance_block/error.html") }.should raise_error(ArgumentError)
    end

    it "should work with super()-like inheritance" do
      Rango::RenderMixin.render("enhance_block/basic.html")
    end

    it "should do nothing if the value or block is nil" do
      output = Rango::RenderMixin.render("enhance_block/nil.html")
      output.strip.should eql("Original")
    end
  end
end
