# encoding: utf-8

class Spec < Thor
  def initialize
    gem "rspec"
    require "spec/autorun"
  end

  desc "rango [path]", "Run Rango specs"
  def rango(path = "spec")
    spec(path, "--options", "spec/spec.opts")
  end

  desc "stubs", "Create stubs of all library files."
  def stubs
    Dir.glob("lib/**/*.rb").each do |file|
      specfile = file.sub(/^lib/, "spec").sub(/\.rb$/, '_spec.rb')
      unless File.exist?(specfile)
        %x[mkdir -p #{File.dirname(specfile)}]
        %x[touch #{specfile}]
        puts "Created #{specfile}"
      end
    end
    (Dir.glob("spec/rango/**/*.rb") + ["spec/rango_spec.rb"]).each do |file|
      libfile = file.sub(/spec/, "lib").sub(/_spec\.rb$/, '.rb')
      if !File.exist?(libfile) && File.zero?(file)
        %x[rm #{file}]
        puts "Removed empty file #{file}"
      elsif !File.exist?(libfile)
        puts "File exists just in spec, not in lib: #{file}"
      end
    end
  end

  def spec(*argv)
    ARGV.clear
    ARGV.push(*argv)
    ::Spec::Runner::CommandLine.run
  end
end
