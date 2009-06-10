# encoding: utf-8

# boot: after rango.rb

module Rango
  # This mixin will be included also to project or your custom app main namespace
  module ImportMixin
    # class Project
    #   extend Rango::ImportMixin
    # end
    def self.extended(base)
      unless base.respond_to?(:root)
        class << base
          def root
            File.dirname(caller[1].split(":").first)
          end
        end
      end
    end

    # class Project
    #   class << self
    #     extend Rango::ImportMixin
    #   end
    # end
    def self.included(base)
      unless base.respond_to?(:root)
        base.class_eval do
          def root
            File.dirname(caller.last.split(":").first)
          end
        end
      end
    end

    # @since 0.0.1
    # @example
    #   Project.import("blog/views")
    #   Project.import("blog/views", soft: true)
    # @param [String] path Path to file which will be loaded using +Kernel#load+ if +Project.settings.debug+ is true or +Kernel#require+ if not.
    # @param [Hash[soft: Boolean(default true)], @optional] options
    # @raise [LoadError] Unless <tt>soft: true</tt> option is used, it will raise +LoadError+ if the file wasn't found.
    # @return [Boolean] If loading suceed.
    def import(path, options = Hash.new)
      # it is better than rescue LoadError, because
      # LoadError can be raise inside the required file
      fullpath = self.find_absolute(path)
      if fullpath.nil? && options[:soft]   # any file found and soft importing enabled
        # do nothing
      elsif fullpath.nil? && !options[:soft]            # any file found and soft importing disabled
        raise LoadError, "File #{path.inspect} (treated as #{fullpath.inspect}) doesn't exist"
      elsif !fullpath.nil?                     # the file was found
        Kernel.load(fullpath)
      elsif !fullpath.nil?                    # the file was found
        Kernel.require(fullpath)
      end
    end

    # @since 0.0.2
    def import_first(paths, options = Hash.new)
      paths.each do |path|
        fullpath = self.find_absolute(path)
        next if fullpath.nil?
        return self.import(fullpath, options)
      end
      raise LoadError unless options[:soft]
    end

    # @since 0.0.1
    # @param [String] path Path to loaded file.
    # @return [Boolean] If the loading was successful.
    def import!(path)
      path = File.join(self.root, path)
      file = self.find_absolute(path)
      Kernel.load(file)
    end

    def find(file)
      ["#{file}.rb", file].find do |file|
        File.exist?(file)
      end
    end

    def find_absolute(file)
      file = File.join(self.root, file) unless file.match(%r[^/])
      self.find(file)
    end
  end
end
