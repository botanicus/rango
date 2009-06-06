# coding: utf-8

# I know, I know, we have Rubigen, Templater and others,
# but Rango needs something really simple, so user can
# start work immediately and can't study bloated docs

require "erubis"
require "fileutils"
require "tempfile"
require "find"

# @since 0.0.3
# @example
#   Rango::CLI::Templater.create("my_generator_dir", user: "botanicus", constant: -> { |argv| argv.first.camel_case })
class Rango
  module CLI
    class Templater
      def self.create(*args)
        templater = self.new(*args)
        Rango.logger.debug("Context: #{templater.context.inspect}")
        templater.create
      end

      attr_accessor :context
      def initialize(content_dir, context = Hash.new)
        @content_dir, @context = content_dir, context
      end

      def create
        Find.find(@content_dir) do |template|
          file = self.expand_path(template)
          next if template == @content_dir
          if File.file?(template)
            proceed_file(template, file)
          else
            unless Dir.exist?(file)
              Rango.logger.debug("[MKDIR] #{file}")
              FileUtils.mkdir_p(file)
            end
          end
        end
      end

      protected
      # replace %variable% in file path
      # %name%_controller.rb => application_controller.rb
      def expand_path(file)
        file = self.location(file).sub(/\.rbt$/, "")
        @context.each do |key, value|
          file.gsub!(/%#{Regexp::quote(key)}%/, value.to_s)
        end
        return file
      end

      def location(file)
        file.sub(%r[^#{Regexp::quote(@content_dir)}/?], "")
      end

      def proceed_file(template, file)
        FileUtils.mkdir_p(File.dirname(file))
        if template.end_with?(".rbt")
          if File.exist?(file)
            Rango.logger.debug("[TEMPLATE] #{file} from #{template}")
          else
            Rango.logger.debug("[RETEMPLATE] #{file} from #{template}")
          end
          File.open(file, "w") do |file|
            eruby = Erubis::Eruby.new(File.read(template))
            output = eruby.evaluate(@context)
            file.print(output)
          end
        else # just copy
          if File.exist?(file)
            Rango.logger.debug("[RECOPY] #{file} from #{template}")
            FileUtils.cp_f(template, file)
          else
            Rango.logger.debug("[COPY] #{file} from #{template}")
            FileUtils.cp(template, file)
          end
        end
      end
    end
  end
end
