# encoding: utf-8

module Kernel
  # Require all files matching given glob relative to $:
  #
  # @author Botanicus
  # @since 0.0.3
  # @param [String] library Glob of files to require
  # @param [Hash] params Optional parameters.
  # @option params [String, Array<String>] :exclude File or list of files or globs relative to base directory
  # @raise [LoadError] If base directory doesn't exist
  # @raise [ArgumentError] If first argument isn't a glob
  # @return [Array<String>] List of successfully loaded files
  # @examples
  #   acquire "lib/*"
  #   acquire "lib/**/*", exclude: "**/*_spec.rb"
  #   acquire "lib/**/*", exclude: ["**/*_spec.rb", "lib/init.rb"]
  def acquire(glob, params = Hash.new)
    base, glob = get_base_and_glob(glob)
    $:.compact.find do |path|
      fullpath = File.expand_path(File.join(path, base))
      return __acquire__(fullpath, glob, params) if File.directory?(fullpath)
    end
    raise LoadError, "Directory #{base} doesn't exist in $:"
  end

  # Require all files matching given glob relative to current file
  #
  # @author Botanicus
  # @since 0.0.3
  # @param [String] library Glob of files to require
  # @param [Hash] params Optional parameters.
  # @option params [String, Array<String>] :exclude File or list of files or globs relative to base directory
  # @raise [LoadError] If base directory doesn't exist
  # @raise [ArgumentError] If first argument isn't a glob
  # @return [Array<String>] List of successfully loaded files
  # @examples
  #   acquire "lib/*"
  #   acquire "lib/**/*", exclude: "**/*_spec.rb"
  #   acquire "lib/**/*", exclude: ["**/*_spec.rb", "lib/init.rb"]
  def acquire_relative(glob, params = Hash.new)
    base, glob = get_base_and_glob(glob)
    path = File.dirname(caller[0].split(":").first)
    full = File.expand_path(File.join(path, base))
    raise LoadError, "Directory #{base} doesn't exist in #{path}" unless File.directory?(full)
    return __acquire__(full, glob, params)
  end

  private
  def __acquire__(path, glob, params)
    glob.replace("#{glob}.rb") if glob.eql?("*") || glob.end_with?("/*")
    files = Dir[File.join(path, glob)]
    excludes = [params[:exclude]].flatten.compact
    excludes.map! do |glob|
      fullpath = File.join(path, glob)
      File.file?(fullpath) ? fullpath : Dir[fullpath]
    end
    excludes = excludes.flatten.compact
    files.select do |path|
      if File.file?(path) && !excludes.include?(path)
        require path
      end
    end
  end

  def get_base_and_glob(glob)
    base, glob = glob.match(/^([^*]+)(.*)$/)[1..2]
    raise ArgumentError, "You have to provide glob" if glob.empty?
    return [base, glob]
  end
end

acquire_relative "ext/*", exclude: "thor.rb"
