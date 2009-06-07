# encoding: utf-8

require "rango/ext/thor"

class Bundle < Rango::Tasks
  def initialize(*args)
    self.boot
    super(*args)
  end

  # @since 0.0.1
  desc "install", "install all the runtime dependencies"
  def install
    Rango.dependencies.each(&:install)
  end

  # @since 0.0.1
  desc "list", "list all the runtime dependencies"
  def list
    Rango.dependencies.each do |dependency|
      if dependency.options.empty?
        puts "- #{dependency.name}"
      else
        puts "- #{dependency.name} #{dependency.options}"
      end
    end
  end
end
