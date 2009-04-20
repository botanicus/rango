# coding: utf-8

Project.configure do
  self.router = "urls.rb"
end
# read it: Project.settings.router

Rango::ControllerStrategy.new.register
Rango::CallableStrategy.new.register

# plugins configuration
# Rango::Plugins::Mailer.configure do
# end