# coding: utf-8

# This hook will run before creating the new directory
# You should setup your variables for templates here
# Dir.pwd => the stubs directory location

# rango create app blog post,tag posts,tags
application = ARGV.shift
models = ARGV.shift.split(",")
controller = ARGV.shift.split(",")

context = {application: application, model: model, controller: controller}
Rango::SimpleTemplater.new(context)
