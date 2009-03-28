# coding=utf-8

require "rubygems/specification"

SPECIFICATION = Gem::Specification.new do |s|
  s.name = "rango"
  s.version = "0.0.1"
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.cert_chain = nil
  s.date = Time.now.strftime("%Y-%m-%d")
  s.description = "Rango is ultralightweight, ultracustomizable, ultracool web framework deeply inspired by Django."
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
  s.executables = Dir.glob("bin/*").map { |path| path.sub(%r[bin/], '') }
  s.add_dependency "rack"
  s.add_dependency "term-ansicolor"
  s.add_dependency "thor"
  s.homepage = "http://101ideas.cz"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.1")
  s.rubyforge_project = "rango"
  s.summary = "Rango is ultralightweight, ultracustomizable, ultracool web framework deeply inspired by Django."
end
