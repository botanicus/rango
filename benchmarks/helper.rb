# encoding: utf-8

require "rbench"
require_relative "../lib/rango"

PROJECT_ROOT  = File.join(File.dirname(__FILE__), "..")
RANGO_LIBFILE = File.join(PROJECT_ROOT, "lib", "rango.rb")
