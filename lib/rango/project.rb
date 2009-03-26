Rango.import("settings")

class Project
  class << self
    root = attribute :root, Dir.pwd
    path = attribute :path, Path.new(root)
    name = attribute :name, path.basename

    attribute :settings, Rango::Settings::Framework.new
    attribute :router

    def logger
      Rango::Logger.new.logger
    end

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

    def find_file(path)
      [path, "#{path}.rb"].find { |path| File.exist?(path) }
    end

    def import!(path)
      Kernel.load(Project.root.join(path))
    end

    def configure(&block)
      self.settings.instance_eval(&block)
    end
  end
end
