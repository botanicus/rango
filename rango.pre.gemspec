#!/usr/bin/env gem build
# encoding: utf-8

# You might think this is a terrible mess and guess what, you're
# right mate! However say thanks to authors of RubyGems, not me.
eval(File.read("rango.gemspec")).tap do |specification|
  specification.version = "#{specification.version}.pre"
end
