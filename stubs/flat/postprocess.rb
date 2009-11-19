# encoding: utf-8

require "rango/ext/platform"

hook do |generator, context|
  if Rango::Platform.unix?
  	sh "chmod +x '#{generator.target}'"
  end
end
