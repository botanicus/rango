#!/usr/bin/env gem build
# encoding: utf-8

require "base64"
require File.expand_path("../lib/rango/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "rango"
  s.version = Rango::VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/rango"
  s.summary = "Rango is ultralightweight, ultracustomizable, ultracool web framework deeply inspired by Django."
  s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = Base64.decode64("c3Rhc3RueUAxMDFpZGVhcy5jeg==\n")
  s.has_rdoc = true

  # files
  s.files = `git ls-files`.split("\n")

  s.executables = Dir["bin/*"].map(&File.method(:basename))
  s.default_executable = "rango"
  s.require_paths = ["lib"]

  # Ruby version
  # Current JRuby with --1.9 switch has RUBY_VERSION set to "1.9.2dev"
  # and RubyGems don't play well with it, so we have to set minimal
  # Ruby version to 1.9, even if it actually is 1.9.1
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.9")

  # Dependencies
  # RubyGems has runtime dependencies (add_dependency) and
  # development dependencies (add_development_dependency)
  # Rango isn't a monolithic framework, so you might want
  # to use just one specific part of it, so it has no sense
  # to specify dependencies for the whole gem. If you want
  # to install everything what you need for start with Rango,
  # just run gem install rango --development

  s.add_development_dependency "simple-templater", ">= 0.0.1.2"
  s.add_development_dependency "bundler", ">= 0.9"

  begin
    require "changelog"
  rescue LoadError
    warn "You have to have changelog gem installed for post install message"
  else
    s.post_install_message = CHANGELOG.new.version_changes
  end

  # RubyForge
  s.rubyforge_project = "rango"
end
