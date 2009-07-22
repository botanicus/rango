class File
  # File.puts "~/.bashrc", source
  def self.puts(file, *chunks)
    self.write(:puts, file, *chunks)
  end

  # File.print "~/.bashrc", source
  def self.print(file, *chunks)
    self.write(:print, file, *chunks)
  end

  # File.printf "~/.bashrc", source, "%d %04x", 123, 123
  def self.print(file, format, *chunks)
    self.write(:printf, file, format, *chunks)
  end

  # File.write :printf, "~/.bashrc", source, "%d %04x", 123, 123
  def self.write(method, file, *args)
    file = File.expand_path(file)
    self.open(file, "w") { |file| file.send(method, *args) }
  end
end
