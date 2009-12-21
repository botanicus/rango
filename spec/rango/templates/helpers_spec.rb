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

    it "should work with blocks" do
      partial "partial_with_block.html.haml"
    end
  end
end
