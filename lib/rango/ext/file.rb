# encoding: utf-8

class File
  # File.append "~/.bashrc", source
  def self.append(file, *chunks)
    self.write(:puts, "a", file, *chunks)
  end

  # File.append "~/.bashrc", source
  def self.add(file, *chunks)
    self.write(:print, "a", file, *chunks)
  end

  # File.puts "~/.bashrc", source
  def self.puts(file, *chunks)
    self.write(:puts, "w", file, *chunks)
  end

  # File.print "~/.bashrc", source
  def self.print(file, *chunks)
    self.write(:print, "w", file, *chunks)
  end

  # File.write :printf, "w", "~/.bashrc", "%d %04x", 123, 123
  def self.write(method, mode, file, *args)
    self.expand_path(file).tap do |path|
      self.open(path, mode) { |file| file.send(method, *args) }
    end
  end
end
