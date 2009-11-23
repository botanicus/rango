#!/usr/bin/env gem1.9 build
# encoding: utf-8

Dir[File.join(File.dirname(__FILE__), "vendor", "*")].each do |path|
  if File.directory?(path) && Dir["#{path}/*"].empty?
    warn "Dependency #{File.basename(path)} in vendor seems to be empty. Run git submodule init && git submodule update to checkout it."
  elsif File.directory?(path) && File.directory?(File.join(path, "lib"))
    $:.unshift File.join(path, "lib")
  end
end

# Run thor package:gem or gem build rango.gemspec
# NOTE: we can't use require_relative because when we run gem build, it use eval for executing this file
require File.join(File.dirname(__FILE__), "lib", "rango")

Gem::Specification.new do |s|
  s.name = "rango"
  s.version = Rango::VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/rango"
  s.summary = "Rango is ultralightweight, ultracustomizable, ultracool web framework deeply inspired by Django."
  s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")
  s.has_rdoc = true

  # files
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*") - Dir.glob("vendor/*") - Dir.glob("doc/*")
  s.executables = ["rango"]
  s.default_executable = "rango"
  s.require_paths = ["lib"]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new(">= 1.9.1")

  # runtime dependencies
  s.add_dependency "rack", "1.0.1"
  s.add_dependency "rubyexts"
  s.add_dependency "media-path"

  # development dependencies
  # use gem install rango --development if you want to install them
  # s.add_development_dependency "simple-templater"
  # s.add_development_dependency "bundler"
  # NOTE: OK, these dependencies aren't actually development, because
  # development dependency of rack is mongrel and mongrel can't be compiled on Ruby 1.9
  s.add_dependency "simple-templater"
  s.add_dependency "bundler"

  # RubyForge
  s.rubyforge_project = "rango"
end
