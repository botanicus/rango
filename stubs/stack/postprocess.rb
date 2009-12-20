# encoding: utf-8

# This hook will be executed after templater finish in context of current generator object.
# Current directory is what you just generated, unless this is flat generator.

require "simple-templater/hooks/postprocess/git_repository"

unless RUBY_PLATFORM.match(/mswin|mingw/)
  sh "chmod +x init.rb"
  sh "chmod +x config.ru"
end

hook do |generator, context|
  generator.after(Hooks::GitRepository)
end
