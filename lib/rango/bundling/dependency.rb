# coding=utf-8

Rango.import("bundling/strategies")

class Rango
  class << self
    # @since 0.0.1
    # @return [String] Returns current environment name. Possibilities are +development+ or +production+.
    attribute :environment, "development"

    attribute :dependencies, Hash.new
    # @examples
    #   Rango.dependency("dm-core", github: "datamapper/dm-core")
    #   Rango.dependency("dm-core", "1.0.2", svn: "datamapper/dm-core")
    #   Rango.dependency("dm-core", "1.0.2", gem: "datamapper/dm-core")
    #   Rango.dependency("a-rango-plugin") do
    #     # code which will be called when the library is imported
    #   end
    # </pre>
    #
    # === Bundling:
    # Dependencies aren't good just for importing libraries, but also for their bundling. It's the reason why we have +github+, +git+, +svn+ and +gem+ options.
    #
    # @since 0.0.1
    # @param [String] library Library to require
    # @param [String] version Which version should be required (optional)
    # @param [Hash] options Available options: <tt>soft: boolean</tt>, <tt>github: user/repo</tt>, <tt>git: repo</tt>, <tt>svn: repo</tt>, <tt>gem: gemname</tt>.
    # @raise [LoadError] Unless soft importing is enable, it will raise LoadError if the file wasn't found
    # @return [Boolean] Returns true if importing succeed or false if not.
    def dependency(library, options = Hash.new)
      self.bundle(library, options)
      if options[:as]
        require options[:as]
      else
        require library
      end
    end

    # @since 0.0.1
    # options[:version]
    # you may need to bundle software which you do not use at the moment. For example on development machine you are using SQLite3, but on server you are using MySQL, so you will need to bundle do_mysql as well.
    def bundle(library, options = Hash.new)
      self.dependencies[library] = {options: options}
    end

    def bundle!
      self.dependencies.each do |library, options|
        #
      end
    end
  end
end