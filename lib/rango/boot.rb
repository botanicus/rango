require "ostruct"
Rango.import("project")

# === Boot sequence:
# 1) logger
# 2) Project
# 3) init & dependencies (we must load the plugins before they will be configured)
# 4) settings

# project
class Rango
  class << self
    # @return [String] Returns current environment name. Possibilities are +development+ or +production+.
    attribute :environment, "development"

    # === Examples:
    # <pre>
    # Rango.dependency("dm-core", :github => "datamapper/dm-core")
    # Rango.dependency("dm-core", "1.0.2", :svn => "datamapper/dm-core")
    # Rango.dependency("dm-core", "1.0.2", :gem => "datamapper/dm-core")
    # Rango.dependency("a-rango-plugin") do
    #   # code which will be called when the library is imported
    # end
    # </pre>
    # 
    # === Bundling:
    # Dependencies aren't good just for importing libraries, but also for their bundling. It's the reason why we have +github+, +git+, +svn+ and +gem+ options.
    #
    # @param [String] library Library to require
    # @param [String] version Which version should be required (optional)
    # @param [Hash] options Available options: <tt>:soft => boolean</tt>, <tt>:github => user/repo</tt>, <tt>:git => repo</tt>, <tt>:svn => repo</tt>, <tt>:gem => gemname</tt>.
    # @raise [LoadError] Unless soft importing is enable, it will raise LoadError if the file wasn't found
    # @return [Boolean] Returns true if importing succeed or false if not.
    def dependency(library, version = nil, options = Hash.new)
      require library
    end
  end
end

# init.rb
Rango.import("router/router") # so user can register strategies in settings or init file
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
