# encoding: utf-8

# This hook will be executed after templater finish in context of current generator object.
# Current directory is what you just generated, unless this is flat generator.

require "rango/ext/platform"

hook do |generator, context|
  if Rango::Platform.unix?
  	sh "chmod +x '#{generator.target}'"
  end
end
