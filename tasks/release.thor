# coding=utf-8

rango_root = File.join(File.dirname(__FILE__), '..')
require File.join(rango_root, "lib", "rango")

class Release < Thor
  desc "all", "Run all the tasks related with releasing new version."
  def all
    print "Have you updated version and codename in lib/rango.rb? [y/N] "
    exit unless STDIN.readline.chomp.downcase.eql?("y")
    self.doc
    self.tmbundle
    Gem.new.package
    self.gems
    self.tag
    self.rubyforge
  end

  desc "doc", "Freeze documentation."
  def doc
    Yardoc.new.generate
    freezed_dir = "doc/#{Rango.version}"
    %x[cp -R doc/head #{freezed_dir}]
    %x[git add #{freezed_dir}]
    %x[git commit #{freezed} -m "Documentation for version #{Rango.version} freezed."]
    puts "Documentation freezed to #{doc_dir}"
  end

  desc "tag", "Create Git tag for this version and push it to GitHub."
  def tag
    %x[git tag -a -m 'Version #{Rango.version} "#{Rango.codename}"' #{Rango.version}]
    %x[git push --tags]
    puts "Tag #{Rango.version} was created and pushed to GitHub."
  end
  
  desc "rubyforge", "Push sources to RubyForge."
  def rubyforge
    %x[git push rubyforge master]
    %x[git push --tags]
  end

  desc "gems", "Propagate the gems to the RubyForge."
  def gems
    # TODO
    puts "Task for propagating gems to RubyForge isn't written yet. Please do so."
  end
  
  desc "tmbundle", "Upgrade the TextMate bundle."
  def tmbundle
    bundle = "Rango.tmbundle"
    %x[rm -rf support/#{bundle}]
    %x[cp -R "#{ENV["HOME"]}/Library/Application\ Support/TextMate/Bundles/#{bundle}" support/]
    %x[git add support/#{bundle}]
    %x[git commit support/Rango.tmbundle -m "Updated Rango TextMate bundle."]
  end
end