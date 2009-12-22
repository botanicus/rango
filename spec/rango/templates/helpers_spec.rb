# encoding: utf-8

require_relative "../../spec_helper"
require "rango/templates/helpers"

Rango::Template.template_paths.clear.push(File.join(STUBS_ROOT, "templates"))

describe Rango::TemplateHelpers do
  include Rango::TemplateHelpers
  describe "#partial" do
    it "should work" do
      partial "basic.html"
    end

    it "should share context with the parent template"
    it "should be able to specify additional context which isn't propagated to the parent template"
  end

  describe "#includes" do
    require "rango/mixins/render"
    it "should return true" do
      includes("library.html").should be_true
    end

    it "should work with blocks" do
      Rango::RenderMixin.render("includes.html")
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
    it "should work with super()-like inheritance" do
      Rango::RenderMixin.render("extend_block.html")
    end
  end
end
