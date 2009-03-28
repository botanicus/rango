# coding=utf-8

require "rubygems/specification"

SPECIFICATION = Gem::Specification.new do |s|
  s.name = "rango"
  s.version = "0.0.2"
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/rango"
  s.summary = "Rango is ultralightweight, ultracustomizable, ultracool web framework deeply inspired by Django."
  s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
  s.executables = Dir.glob("bin/*").map { |path| path.sub(%r[bin/], '') }
  s.default_executable = "rango"
  s.add_dependency "rack"
  s.add_dependency "term-ansicolor"
  s.add_dependency "thor"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.1")
  s.rubyforge_project = "rango"
end
