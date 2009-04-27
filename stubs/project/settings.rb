# coding: utf-8

Project.configure do
  self.router = "urls.rb"
end
# read it: Project.settings.router

Rango::ControllerStrategy.register
Rango::CallableStrategy.register

# plugins configuration
# Rango::Plugins::Mailer.configure do
# end
