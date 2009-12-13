# encoding: utf-8

# This hook will be executed after templater finish in context of current generator object.
# Current directory is what you just generated, unless this is flat generator.

require "rubyexts/platform"
require "simple-templater/hooks/postprocess/git_repository"

if RubyExts::Platform.unix?
	sh "chmod +x init.rb"
  sh "chmod +x config.ru"
end

hook do |generator, context|
  generator.after(Hooks::GitRepository)
  # TODO: this is probably not the best way how to do it
  args = Array.new
  args.push("--orm=#{context[:orm]}") if context[:orm]
  args.push("--models=#{context[:models].join(",")}") unless context[:models].empty?
  args.push("--controllers=#{context[:controllers].join(",")}") unless context[:controllers].empty?
  sh "rango create app #{context[:name]} #{args.join(" ")}"
end
