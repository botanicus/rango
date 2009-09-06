# encoding: utf-8

# Run thor package:gem or gem build rango.gemspec
$:.unshift(File.join(File.dirname(__FILE__), "lib"))

begin
  require "rubygems/specification"
rescue SecurityError
  # http://gems.github.com
end

::Gem::Specification.new do |s|
  s.name = "rango"
  s.version = 0.0.3
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/rango"
  s.summary = "Rango is ultralightweight, ultracustomizable, ultracool web framework deeply inspired by Django."
  s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")

  # files
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
  s.executables = ["rango"]
  s.default_executable = "rango"
  s.require_paths = ["lib"]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new(">= 1.9.1")

  # runtime dependencies
  s.add_dependency "rack"
  s.add_dependency "extlib"
  s.add_dependency "path"

  # development dependencies
  # use gem install rango --development if you want to install them
  s.add_development_dependency "erubis"
  s.add_development_dependency "thor"

  # RubyForge
  s.rubyforge_project = "rango"
end
