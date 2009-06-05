# coding: utf-8

require "fileutils"
require_relative "../lib/rango/ext"

# TODO: short vs. long formating (just libs, specs etc or them + each file)
# TODO: proper indentation (1<space>, but 12<space> => bad indentation) => format string
class Stats < Thor
  self.default_task(:all)

  def initialize
    @altogether = 0
  end

  desc "all", "Lines of code altogether"
  def all
    self.run(:libs, :specs, :tasks, :hooks)
    self.altogether(@altogether)
  end

  desc "libs", "Lines of code in library"
  def libs
    self.count(Dir.glob("lib/rango/**/*.rb") + ["lib/rango.rb"])
  end

  desc "specs", "Lines of code in specs"
  def specs
    self.count(Dir.glob("spec/**/*_spec.rb"))
  end

  desc "tasks", "Lines of code in tasks"
  def tasks
    self.count(Dir.glob("tasks/*.thor"))
  end

  desc "hooks", "Lines of code in support/hooks"
  def hooks
    self.count(Dir.glob("support/hooks/*"))
  end

  protected
  def count(files)
    altogether = 0
    files.each do |file|
      count = File.readlines(file).count
      unless count == 0
        puts "#{count.to_s.colorize.green}  #{file}"
        altogether += count
      end
    end
    self.altogether(altogether)
    @altogether += altogether
    return altogether
  end

  def run(*tasks)
    tasks.each do |task|
      self.send(task)
      puts
    end
  end

  def altogether(count)
    puts "=> ".colorize.red.to_s + "#{count}".colorize.green.to_s + " lines of code".colorize.yellow.to_s
  end
end
