# encoding: utf-8

require "rango" # logger

require "yaml"
require "ostruct"
require "fileutils"
try_require_gem "erubis"

require_relative "templater"

# TODO
# metadata :file option for rendering just one file
# gem installation (for plugin)
# usage on rango -h
# !!! @models.each |model| => create models/%model%.rb

# - Find possible location and take first one
# - If type of the location is full, then copy it's content directory to the desired name
# - If type of the location is diff, then take another location, copy it and then copy files from the first one
# - Run init.rb

# === Hooks ===

# == preprocessing.rb ==
# @foo = "bar"
# <%= %> a <%% %%>

# models/%model%.rb
# model.rb.rbt, posts.html.erb.rbt

# content/foo
# xxx/bar
# => rango generate bigproject blog --models=post,tag --controllers=posts,tags

module Rango
  module CLI
    class Generator
      def self.rango_root
        File.expand_path(File.join(File.dirname(__FILE__), "..", "..", ".."))
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

      def initialize(type, name, *args)
        @type, @name, @args = type, name, args
        if File.exist?(name)
          abort "#{name} already exist, aborting."
        end
      end

      def stubs_dirs
        dirs = self.class.stubs_dirs.dup
        dirs.map! { |dir| "#{dir}/#{@type}" }
        dirs.find { |dir| Dir.exist?(dir) }
      end
      
      def content_dir
        "#{@stubs_dir}/content"
      end

      def create
        self.stubs_dirs.each do |stubs_dir|
          @stubs_dir = stubs_dir
          self.proceed
        end
      end
      
      def proceed
        Rango.logger.info("Creating #{@type} #{@name} from stubs in #{@stubs_dir}")
        FileUtils.mkdir_p(@name)
        Dir.chdir(@name) do
          ARGV.clear.push(*[self.content_dir, @args].flatten.compact)
          if File.exist?(hook = File.join(@stubs_dir, "preprocess.rb"))
            load hook
          else
            Rango::CLI::Templater.create(self.content_dir)
          end
        end
        self.run_init_hook
      end

      def run_init_hook
        Dir.chdir(@name) do
          if File.exist?(hook = File.join(@stubs_dir, "postprocess.rb"))
            load(hook) && Rango.logger.inspect("Running postprocess.rb hook")
          end
        end
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
      rescue Errno::ENOENT
        Rango.logger.fatal("Rango expected '#{metadata_file}'")
      end

      def config
        defaults = {processing: true, type: "full"}
        OpenStruct.new(defaults.merge(self.metadata))
      end
    end
  end
end
