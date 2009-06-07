# encoding: utf-8

specroot = File.dirname(__FILE__)
require File.join(specroot, "..", "lib", "rango")
require File.join(specroot, "factories.rb")

Rango.boot(flat: true)
