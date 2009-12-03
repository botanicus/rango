# encoding: utf-8

require "rango/project"

Project.configure do
  # write it: self.feature = value
  # read it:  Project.settings.feature
  self.orm = :datamapper
end

# plugins configuration
# Rango::Plugins::Mailer.configure do
# end
