#!/usr/bin/env ruby1.9

require "rango/ext/platform"

if Rango::Platform.unix?
	sh "chmod +x init.rb"
	sh "chmod +x config.ru"
end
