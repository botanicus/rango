# coding=utf-8

require "ostruct"
Rango.import("project")
Rango.import("router/router")
Rango.import("request")

Rango.import("helpers")
Rango.import("bundling/dependency")
Rango::HttpExceptions::HttpError.send(:include, Rango::Helpers)

# === Boot sequence:
# 1) logger
# 2) Project
# 3) init & dependencies (we must load the plugins before they will be configured)
# 4) settings

# project
class Rango
  class << self
    # @since 0.0.1
    # @return [String] Returns current environment name. Possibilities are +development+ or +production+.
    attribute :environment, "development"
  end
end

if Rango.flat?
  # FIXME: this doesn't work at the moment
  Rango.logger.debug("Loading flat application")
else
  # init.rb
  Project.import("init", :soft => true, :verbose => false)

  # settings.rb
  begin
    Project.import("settings")
  rescue LoadError
    Rango.logger.fatal("Settings.rb wasn't found or it cause another LoadError.")
  end

  # settings_local.rb
  Project.import("settings_local", :soft => true, :verbose => false)

  # urls.rb
  Project.import(Project.settings.router)
end