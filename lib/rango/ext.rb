# encoding: utf-8

module Kernel
  def acquire(glob, params = Hash.new)
    base, glob = glob.match(/^([^*]+)(.*)$/)[1..2]
    $:.compact.find do |path|
      fullpath = File.join(path, base)
      return __acquire__(fullpath, glob, params) if File.directory?(fullpath)
    end
    raise LoadError, "Directory #{base} doesn't exist in $:" unless path
  end

  def acquire_relative(glob, params = Hash.new)
    base, glob = glob.match(/^([^*]+)(.*)$/)[1..2]
    path = File.dirname(caller[0].split(":").first)
    full = File.join(path, base)
    raise LoadError, "Directory #{base} doesn't exist in #{path}" unless File.directory?(full)
    return __acquire__(full, glob, params)
  end

  private
  def __acquire__(path, glob, params)
    glob.replace("#{glob}.rb") if glob.end_with?("/*")
    files = Dir[File.join(path, glob)]
    excludes = [params[:exclude]].flatten.compact
    excludes.map! do |glob|
      path = File.join(path, glob)
      File.file?(path) ? path : Dir[path]
    end
    excludes = excludes.flatten.compact
    files.select do |path|
      if File.file?(path) && !excludes.include?(path)
        require path
      end
    end
  end
end

acquire_relative "ext/*", exclude: "thor.rb"
