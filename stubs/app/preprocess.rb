# coding: utf-8

# This hook will run before templater creates new files from templates
# You should setup your variables for templates here
# Dir.pwd => the stubs directory location

# rango create app blog post,tag posts,tags
content_dir = ARGV.shift
application = ARGV.shift
models = ARGV.shift.try(:split, ",") || Array.new
controllers = ARGV.shift.try(:split, ",") || Array.new

context = {application: application, models: models, controllers: controllers}
Rango::CLI::Templater.create(content_dir, context)
