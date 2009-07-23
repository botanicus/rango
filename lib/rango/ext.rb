# encoding: utf-8

module Kernel
  def acquire(glob, params = Hash.new)
    path = $:.find { |path| File.directory(path) }
    __acquire__(path, glob, params)
  end

  def acquire_relative(glob, params = Hash.new)
    path = File.dirname(caller[0].split(":").first)
    __acquire__(path, glob, params)
  end

  private
  def __acquire__(path, glob, params)
    glob.replace("#{glob}.rb") if File.split(path).last.eql?("*")
    files = Dir[File.join(path, glob)]
    return if files.empty?
    excludes = [params[:exclude]].flatten
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

acquire_relative "ext/*", exclude: "ext/thor.rb"
