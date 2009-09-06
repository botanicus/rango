# encoding: utf-8

class Release < Thor
  def initialize
    require_relative "../lib/rango"
    load "#{File.dirname(__FILE__)}/yardoc.thor"
    load "#{File.dirname(__FILE__)}/../rango.gemspec"
  end

  desc "all", "Run all the tasks related with releasing new version."
  def all(password)
    print "Have you updated version and codename in lib/rango.rb? [y/N] "
    exit unless STDIN.readline.chomp.downcase.eql?("y")
    self.doc
    self.tmbundle
    Gem.new.package
    self.tag
    self.rubyforge
    self.twitter(password)
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
  rescue
    puts "Documentation generation failed."
  end

  desc "tag", "Create Git tag for this version and push it to GitHub."
  def tag
    puts "Creating new git tag #{Rango::VERSION} and pushing it online ..."
    %x[git tag -a -m 'Version #{Rango::VERSION}' #{Rango::VERSION}]
    %x[git push --tags]
    puts "Tag #{Rango::VERSION} was created and pushed to GitHub."
  end

  desc "rubyforge", "Push sources to RubyForge."
  def rubyforge
    # ATM RubyForge seems to not work correctly with SSH keys
    # puts "Pushing sources to RubyForge ..."
    # %x[git push rubyforge master]
    # %x[git push --tags]

    puts "Pushing packages to RubyForge ..."
    %x[rubyforge login]
    file = Dir["pkg/*.gem"].last
    # args: rubyforge_project gem_name gem_version gem_file
    %x[rubyforge add_release 8080 rango #{Rango::VERSION} #{file}]
    %x[rubyforge add_file 8080 rango #{Rango::VERSION} #{file}]
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

  desc "twitter", "Send message to Twitter"
  def twitter(password)
    message = "Rango #{Rango::VERSION} have been just released! Install via RubyGems from RubyForge or GitHub!"
    %x[curl --basic --user RangoProject:#{password} --data status="#{message}" http://twitter.com/statuses/update.xml > /dev/null]
    puts "Message have been sent to Twitter"
  end
end
