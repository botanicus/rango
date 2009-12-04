# encoding: utf-8

desc "Release new version of rango"
task release: ["release:tag", "release:gemcutter", "release:twitter"]

namespace :release do
  desc "Create Git tag"
  task :tag do
    require_relative "../lib/rango"
    puts "Creating new git tag #{Rango::VERSION} and pushing it online ..."
    sh "git tag -a -m 'Version #{Rango::VERSION}' #{Rango::VERSION}"
    sh "git push --tags"
    puts "Tag #{Rango::VERSION} was created and pushed to GitHub."
  end

  desc "Push gem to Gemcutter"
  task :gemcutter do
    puts "Pushing to Gemcutter ..."
    sh "gem push #{Dir["*.gem"].last}"
  end
  
  desc "Send message to Twitter"
  task :twitter, :password do
    require_relative "../lib/rango"
    message = "Rango #{Rango::VERSION} have been just released! Install via RubyGems from RubyForge or GitHub!"
    %x[curl --basic --user RangoProject:#{password} --data status="#{message}" http://twitter.com/statuses/update.xml > /dev/null]
    puts "Message have been sent to Twitter"
  end
end

desc "Create and push prerelease gem"
task :prerelease => "build:prerelease" do
  puts "Pushing to Gemcutter ..."
  sh "gem push #{Dir["*.pre.gem"].last}"
end
