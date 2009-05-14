# coding: utf-8

# I know, I know, we have Rubigen, Templater and others, but Rango needs something really simple, so user can start work immediately and can't study bloated docs

require "erubis"
require "fileutils"
require "tempfile"

# TODO
# replace %variable% in file path
# just one file generation (settings, flat.ru)

# @future 0.0.3 It's just a prototype now. But it will be available in 0.0.3. Stay tuned!
# @example
#   Rango::SimpleTemplate.new("my_generator_dir", user: "botanicus", constant: -> { |argv| argv.first.camel_case })
class Rango
  class SimpleTemplate
    attr_accessor :context
    def initialize(path, context = Hash.new)
      @path = path
      @context = context
    end

    def generate
      if Dir.exist?(@path)
        Find.find(@path) do |file|
          # mkdir -p if directory
          # gsub co
          output = proceed_file(file)
          FileUtils.cp(output.path, location)
        end
      else
      end
    end
    
    protected
    def proceed_file(file)
      if file.split(".").last == "rbt" # proceed and copy output
        Tempfile.open(File.basename(file)) do |file|
          file.print(Erubis::Eruby.new(file))
        end
      else # just copy
        File.new(file)
      end
    end
  end
end
