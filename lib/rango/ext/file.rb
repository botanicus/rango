class File
  # File.puts "~/.bashrc", source
  def self.puts(file, *chunks)
    self.write(:puts, file, *chunks)
  end

  # File.print "~/.bashrc", source
  def self.print(file, *chunks)
    self.write(:print, file, *chunks)
  end

  # File.write :printf, "~/.bashrc", "%d %04x", 123, 123
  def self.write(method, file, *args)
    self.expand_path(file).tap do |path|
      self.open(path, "w") { |file| file.send(method, *args) }
    end
  end
end
