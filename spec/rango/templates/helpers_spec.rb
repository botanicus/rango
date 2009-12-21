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
  end

  describe "#includes" do
    require "rango/mixins/render"

    it "should work with blocks" do
      Rango::RenderMixin.render("includes.html")
    end
  end
end
