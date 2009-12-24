#!/usr/bin/env gem build
# encoding: utf-8

# NOTE: we can't use require_relative because when we run gem build, it use eval for executing this file
$:.unshift(File.join(File.dirname(__FILE__), "lib"))
require "rango/version"

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
  s.files = Dir.glob("{bin,lib,spec,stubs}/**/*") + %w[CHANGELOG CONTRIBUTORS LICENSE Rakefile README.textile simple-templater.scope] + Dir.glob("stubs/**/.*") # so .gitignore, .rvmrc, .rvmrc.rbt etc will be in gem
  s.executables = ["rango"]
  s.default_executable = "rango"
  s.require_paths = ["lib"]

  # Ruby version
  # Current JRuby with --1.9 switch has RUBY_VERSION set to "1.9.2dev"
  # and RubyGems don't play well with it, so we have to set minimal
  # Ruby version to 1.9, even if it actually is 1.9.1
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.9")

  # === Dependencies ===
  # RubyGems has runtime dependencies (add_dependency) and
  # development dependencies (add_development_dependency)
  # Rango isn't a monolithic framework, so you might want
  # to use just one specific part of it, so it has no sense
  # to specify dependencies for the whole gem. If you want
  # to install everything, just run gem install rango --development

  # Unfortunatelly Rack has Mongrel as a development dependency and since Mongrel can't be compiled on Ruby 1.9, it won't work. Tell Rack team to fix this shit, not me.
  s.add_development_dependency "rack", ">= 1.0.1"
  s.add_development_dependency "tilt", ">= 0.3"
  s.add_development_dependency "media-path", ">= 0.1.1"
  s.add_development_dependency "simple-templater", ">= 0.0.1.2"
  s.add_development_dependency "bundler"

  s.post_install_message = File.read("CHANGELOG")

  # RubyForge
  s.rubyforge_project = "rango"
end
