#!/usr/bin/env ruby1.9
# encoding: utf-8

require "rango/ext/platform"

if Rango::Platform.unix?
	sh "chmod +x init.rb"
	sh "chmod +x config.ru"
end

if yes?("Do you want to initialize Git repozitory and do initial commit?")
  sh "git init"
  sh "git add ."
  sh "git commit -a -m 'Initial import'"
end
