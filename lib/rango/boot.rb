require "ostruct"
Rango.import("project")

# 1) logger
# 2) Project
# 3) init & dependencies (we must load the plugins before they will be configured)
# 4) settings

# project
class Rango
  class << self
    attribute :environment, "development"
    def dependency(library, options = Hash.new)
      require library
    end
  end
end

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
Rango.import("router/router")
Project.import(Project.settings.router)
