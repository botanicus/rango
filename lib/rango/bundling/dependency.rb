# encoding: utf-8

Rango.import("bundling/strategy")
Rango.import("bundling/strategies/gem")
Rango.import("bundling/strategies/git")

class Rango
  class << self
    # @since 0.0.1
    # @return [String] Returns current environment name. Possibilities are +development+ or +production+.
    attribute :environment, "development"

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

    # TODO: soft option support
    def dependency(library, options = Hash.new, &block)
      dependency = self.bundle(library, options.except(:optional))
      if dependency.nil?
        #
      else
        if options[:optional]
          begin
            dependency.load
          rescue LoadError
            Rango.logger.warn("Dependency #{library} isn't available.")
          end
        else
          dependency.load
        end
        block.call if block_given?
      end
    end

    # @since 0.0.1
    # options[:version]
    # options[:soft] If true, bundle dependency just if isn't bundled yet.
    # you may need to bundle software which you do not use at the moment. For example on development machine you are using SQLite3, but on server you are using MySQL, so you will need to bundle do_mysql as well.
    def bundle(name, options = Hash.new)
      dependency = Rango::Bundling::Strategy.find(name, options)
      if dependency.nil?
        Rango.logger.error("No dependency strategy matched for #{name} with #{options}")
        return nil
      else
        dependency.register
      end
    end
  end
end
