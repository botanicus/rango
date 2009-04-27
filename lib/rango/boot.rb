# coding: utf-8

require "ostruct"
Rango.import("project")
Rango.import("router/router")
Rango.import("rack/request")

Rango.import("ext/time_dsl")

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
  Rango.logger.debug("Loading flat application")
else
  # init.rb
  Project.import_first(["init", "config/init"], soft: true, verbose: false)

  # settings.rb
  begin
    Project.import_first(["settings", "config/settings"])
  rescue LoadError
    Rango.logger.fatal("settings.rb wasn't found or it cause another LoadError.")
    exit
  end

  # TODO: move it somewhere
  if orm = Project.settings.orm
    Rango.import("orm/adapters/#{orm}/setup")
  end

  # settings_local.rb
  Project.import_first(["settings_local", "config/settings_local"], soft: true, verbose: false)

  # urls.rb
  begin
    Project.import(Project.settings.router)
  rescue LoadError
    Rango.logger.fatal("urls.rb wasn't found or it cause another LoadError.")
    exit
  end
end
