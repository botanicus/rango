# coding: utf-8

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
    puts "Freezing documentation ..."
    Yardoc.new.generate
    freezed_dir = "doc/#{Rango::VERSION}"
    %x[cp -R doc/head #{freezed_dir}]
    %x[git add #{freezed_dir}]
    %x[git commit #{freezed_dir} -m "Documentation for version #{Rango::VERSION} freezed."]
    puts "Documentation freezed to #{freezed_dir}"
  end

  desc "tag", "Create Git tag for this version and push it to GitHub."
  def tag
    puts "Creating new git tag #{Rango::VERSION} with description #{Rango::CODENAME} and pushing it online ..."
    %x[git tag -a -m 'Version #{Rango::VERSION} "#{Rango::CODENAME}"' #{Rango::VERSION}]
    %x[git push --tags]
    puts "Tag #{Rango::VERSION} was created and pushed to GitHub."
  end

  desc "rubyforge", "Push sources to RubyForge."
  def rubyforge
    puts "Pushing sources to RubyForge ..."
    %x[git push rubyforge master]
    %x[git push --tags]

    puts "Pushing packages to RubyForge ..."
    packages = %w( gem tgz zip ).collect{ |ext| "pkg/#{GEM_NAME}-#{GEM_VERSION}.#{ext}" }
    sh %{rubyforge login}
    sh %{rubyforge add_release #{RUBY_FORGE_PROJECT} #{GEM_NAME} #{GEM_VERSION} #{packages.join(' ')}}
    sh %{rubyforge add_file #{RUBY_FORGE_PROJECT} #{GEM_NAME} #{GEM_VERSION} #{packages.join(' ')}}
  end

  desc "gems", "Propagate the gems to the RubyForge."
  def gems
    # TODO
    puts "Propagating gems to the RubyForge ..."
    puts "Task for propagating gems to RubyForge isn't written yet. Please do so."
  end

  desc "tmbundle", "Upgrade the TextMate bundle."
  def tmbundle
    puts "Updating the TextMate bundle ..."
    bundle = "Rango.tmbundle"
    %x[rm -rf support/#{bundle}]
    %x[cp -R "#{ENV["HOME"]}/Library/Application\ Support/TextMate/Bundles/#{bundle}" support/]
    %x[git add support/#{bundle}]
    %x[git commit support/Rango.tmbundle -m "Updated Rango TextMate bundle."]
  end
end
