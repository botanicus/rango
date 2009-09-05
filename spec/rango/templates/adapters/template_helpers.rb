# encoding: utf-8

require "tempfile"
require "fileutils"
require_relative "../../../spec_helper"

# stubs
#Project = OpenStruct.new(settings: Hash.new)

# helpers
module TemplateHelpers
  STUBS_ROOT = File.join(SPEC_ROOT, "stubs/templates")

  def template_path(basename)
    File.join(STUBS_ROOT, basename)
  end

  def template(basename)
    File.new(template_path(basename))
  end

  def edit_template(&block)
    file = Tempfile.open("template")
    file.puts(block.call(@template.read))
    file.open
  end

  def clean_cache
    Dir["#{STUBS_ROOT}/*.cache"].each do |file|
      FileUtils.rm(file)
    end
  end

  def settings(options = Hash.new)
    settings = {template: {caching: false, autoescape: true}}
    RecursiveOpenStruct.new(settings.merge(options))
  end
end
