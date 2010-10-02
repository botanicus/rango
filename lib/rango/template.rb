# encoding: utf-8

begin
  require "template-inheritance"
rescue LoadError
  raise LoadError, "You have to install the template-inheritance gem if you want to use templates!"
end

TemplateInheritance::Template.paths << Rango.root.join("templates").to_s
TemplateInheritance.logger = Rango.logger
