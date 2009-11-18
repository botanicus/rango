#!/usr/bin/env ruby1.9
# encoding: utf-8

require "rango/ext/platform"
require "simple-templater/hooks/postprocess/git-repository"

if Rango::Platform.unix?
	sh "chmod +x init.rb"
	sh "chmod +x config.ru"
end

SimpleTemplater::Hooks::GitRepository.invoke
