# encoding: utf-8

# TODO: rango-head.gemspec for git HEAD package (version Time.now.to_i or so)
class Prerelease < Thor
  def initialize
    require_relative "../lib/rango"
    load "#{File.dirname(__FILE__)}/yardoc.thor"
    load "#{File.dirname(__FILE__)}/../rango.gemspec"
  end

  desc "prerelease", "Build prerelease gems"
  def build
    gemspec = File.read("rango.gemspec")
    spec = eval(gemspec)
    ::Gem::Builder.new(spec).build
    FileUtils.mv(spec.file_name, spec.file_name.sub(/\.gem$/, "pre\&"))
  end
  
  desc "push", "Push prerelease gems to GemCutter.org"
  def push
    puts "Pushing to gemcutter ..."
    puts %x[gemcutter push #{pregem}]
    system "rm #{pregem}"
  end

  protected
  def pregem
    Dir["pkg/*pre.gem"].last
  end

  def gem
    Dir["pkg/*.gem"].last
  end
end
