# encoding: utf-8

# This hook will run before templater creates new files from templates
# You should setup your variables for templates here
# Dir.pwd => the stubs directory location

# rango create app blog post,tag posts,tags
require "simple-templater/argv_parsing"

options = ARGV.parse!
models  = options[:models] || Array.new
controllers = options[:controllers] || Array.new
{models: models, controllers: controllers}
