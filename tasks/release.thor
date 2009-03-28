class Release < Thor
  def all(version)
    self.version(version)
    self.doc(version)
    self.tag(version)
    Gem.new.package
    self.gems
  end

  def version(version)
    content = File.read("rango.gemspec")
    content.gsub!(/version = "\d+\.\d+\.\d+"/, "version = \"#{version}\"")
    File.open("rango.spec", "w") do |file|
      file.puts(content)
    end
    %x[git commit rango.gemspec -m "Version increased to #{version}."]
  end

  desc "doc", "Freeze documentation."
  def doc(version)
    Yardoc.new.generate
    %x[cp -R doc/head doc/#{version}]
    %x[git add doc/#{version}]
    %x[git commit doc/#{version} -m "Documentation for version #{version} freezed."]
  end

  desc "tag", "Create Git tag for this version"
  def tag(version)
    # TODO
  end

  desc "gems", "Propagate the gems to the RubyForge."
  def gems
    # TODO
  end
end