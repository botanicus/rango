# coding: utf-8

require "yaml"
require "ostruct"
require "fileutils"
require "rango" # logger
require "erubis"

# TODO
# metadata :file option for rendering just one file
# gem installation (for plugin)
# prazdne .gitignore kvuli gitu

# - Find possible location and take first one
# - If type of the location is full, then copy it's content directory to the desired name
# - If type of the location is diff, then take another location, copy it and then copy files from the first one
# - Run init.rb

# preprocessing.rb
# @foo = "bar"

# erubis
# <%= %> a <%% %%>

# models/%model%.rb
# model.rb.rbt, posts.html.erb.rbt

# content/foo
# xxx/bar
# => rango generate bigproject blog --models=post,tag --controllers=posts,tags
# iterovat pres kolekce => to uz vyzaduje templatovaci engine

class Rango
  class Project
    def self.rango_root
      File.join(File.dirname(__FILE__), "..", "..", "..")
    end

    def self.stubs_dirs
      ["#{ENV["HOME"]}/.rango/stubs", "#{self.rango_root}/stubs"]
    end

    def self.list
      output = Hash.new
      self.stubs_dirs.each do |directory|
        files = map { |directory| Dir["#{directory}/*"] }.flatten
        directories = files.select { |file| Dir.exist?(file) }
        output[directory] = directories
      end
      return output
    end

    def initialize(type, name)
      dir = stubs_dirs.find { |dir| File.exist?("#{dir}/#{type}") }
      if File.exist?(name)
        abort "#{name} already exist, aborting."
      end
    end
    
    def create
      if self.config.type == "diff"
      elsif self.config.type == "full"
        # TODO: log it
        FileUtils.cp_r(File.join(dir, type), name)
        puts "#{type.capitalize} #{name} have been created (used stub from #{dir})."
      end
      load "init.rb"
    end
    
    def validations
      ["diff", "full"].include?(self.config.type)
    end
    
    # Metadata options
    # :type: full|diff
    # :file: flat.ru
    def metadata
      metadata_file = File.join(@stubs_dir, "metadata.yml")
      YAML::load_file(metadata_file)
    end
    
    def config
      defaults = {processing: true, type: "full"}
      OpenStruct.new(defaults.merge(self.metadata))
    end
  end
end
