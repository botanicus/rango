# coding=utf-8

Rango.import("settings")

class Project
  class << self
    # @since 0.0.1
    # @return [String] String reprezentation of project root directory.
    root = attribute :root, Dir.pwd

    # @since 0.0.1
    # @see Path
    # @return [Path] Path reprezentation of project root directory.
    path = attribute :path, Path.new(root)

    # @since 0.0.1
    # @return [String] Name of the project. Taken from basename of project directory.
    name = attribute :name, path.basename

    # @since 0.0.1
    # @return [Rango::Settings::Framework] Project settings.
    attribute :settings, Rango::Settings::Framework.new

    # @since 0.0.1
    # @return [Rango::Router] Project main router.
    attribute :router

    # @since 0.0.1
    # @return [Rango::Logger] Logger for project related stuff.
    attribute :logger, Rango::Logger.new

    # @since 0.0.1
    # @example
    #   Project.import("blog/views")
    #   Project.import("blog/views", :soft => true)
    # @param [String] path Path to file which will be loaded using +Kernel#load+ if +Project.settings.debug+ is true or +Kernel#require+ if not.
    # @param [Hash[:soft => Boolean(default true)], @optional] options
    # @raise [LoadError] Unless <tt>:soft => true</tt> option is used, it will raise +LoadError+ if the file wasn't found.
    # @return [Boolean] If loading suceed.
    def import(path, options = Hash.new)
      # it is better than rescue LoadError, because
      # LoadError can be raise inside the required file
      path = path.relative if path.is_a?(Path)
      fullpath = find_file(File.join(Project.root, path)) # TODO: what if fullpath is already given?
      debug = Project.settings.respond_to?(:debug) && Project.settings.debug
      if fullpath.nil? && options[:soft] && debug       # any file found, debug mode and soft importing enabled
        Project.logger.warn("File #{path} not found")
      elsif fullpath.nil? && options[:soft] && !debug   # any file found, debug mode and soft importing enabled
        # do nothing
      elsif fullpath.nil? && !options[:soft]            # any file found, debug mode and soft importing disabled
        raise LoadError, "#{path.inspect} vas given, expected string with path to file"
      elsif !fullpath.nil? && debug                     # the file was found
        Project.logger.debug("Loading #{path}")
        Kernel.load(fullpath)
      elsif !fullpath.nil? && !debug                    # the file was found
        Kernel.require(fullpath)
      end
    end

    def import_first(paths, options = Hash.new)
      paths.each do |path|
        path = path.relative if path.is_a?(Path)
        fullpath = find_file(File.join(Project.root, path))
        next if fullpath.nil?
        return Project.import(fullpath, options)
      end
      raise LoadError unless options[:soft]
    end

    # @since 0.0.1
    # @param [String] path Path to loaded file.
    # @return [Boolean] If the loading was successful.
    # TODO: use find_file
    def import!(path)
      Kernel.load(Project.root.join(path))
    end

    # @since 0.0.1
    # @example
    #   Project.configure do
    #     self.property = "value"
    #   end
    # @yield [block] Block which will be evaluated in Project.setttings object.
    # @return [Rango::Settings::Framework] Returns project settings.
    def configure(&block)
      self.settings.instance_eval(&block)
    end

    private
    def find_file(path)
      # first try to match .rb version, because there may be views.rb and views/
      path = ["#{path}.rb", path].find { |path| File.exist?(path) }
      path = Path.new(path)
      path.relative
    rescue
      return nil
    end
  end
end
