# coding: utf-8

# This hook will run before templater creates new files from templates
# You should setup your variables for templates here
# Dir.pwd => the stubs directory location

Rango::CLI::Templater.create(ARGV.shift, user: ENV["USER"])
