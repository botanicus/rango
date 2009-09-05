# encoding: utf-8

# dependencies
Rango.bundle "rango"
Rango.dependency "rack"
Rango.dependency "extlib"

# imports
Rango.import("project")
Rango.import("rack/request")
Rango.import("helpers")
Rango.import("router/adapters/basic")

Rango::HttpExceptions::HttpError.send(:include, Rango::Helpers)

# === Boot sequence:
# 1) logger
# 2) Project
# 3) init & dependencies (we must load the plugins before they will be configured)
# 4) settings

# project
module Rango
  class << self
    # @since 0.0.1
    # @return [String] Returns current environment name. Possibilities are +development+ or +production+.
    attribute :environment, "development"
  end
end

# The only file which Rango really requires is init.rb,
# where is expected that you setup database connection,
# require gems etc. However if you really want to, you
# can bypass loading of init.rb and ORM setup.
# This is useful mostly for one file applications

# Ruby Enterprise Edition doesn't support Ruby 1.9 yet, but when it will, we will ready
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

# Rango.reloader.setup_signals

module Rango
  class BootLoader
    def load_settings
      begin
        Project.logger.info("Reading settings")
        Project.import_first(["settings", "config/settings"], soft: true)
      rescue LoadError
        Rango.logger.fatal("settings.rb wasn't found or it cause another LoadError.")
        exit 1
      end

      # settings_local.rb
      Project.import_first(["settings_local", "config/settings_local"], soft: true, verbose: false)
    end

    def setup_orm
      if orm = Project.settings.orm
        unless Rango.import("orm/adapters/#{orm}/setup", soft: true, verbose: false)
          Project.logger.error("ORM #{orm} isn't supported. You will need to setup your database connection manually.")
        end
      end
    end
  end
end
