# encoding: utf-8

# TODO: run it as git hook before commit
class Repair < Thor
  desc "all", "Repair encoding, shebang and whitespace"
  def all
    self.encoding
    self.whitespace
    self.eof
  end

  desc "encoding", "Add missing coding declaration"
  def encoding
    ruby_files do |file, lines, original|
      if lines.length > 1 && ! lines.first.match(/^# encoding: utf-8\s*$/)
        puts "Added missing coding declaration to #{file}"
        lines.insert(0, "# encoding: utf-8\n\n")
        self.save(file, lines)
      end
    end
  end

  desc "whitespace", "Remove extra whitespace"
  def whitespace
    ruby_files do |file, lines, original|
      lines = original.map { |line| line.chomp(" ") }
      if original != lines
        puts "Removed extra whitespace from #{file}"
        self.save(file, lines)
      end
    end
  end

  desc "eof", "Add missing \\n to the end of files"
  def eof
    ruby_files do |file, lines, original|
      if original.last && ! original.last.match(/\n$/)
        puts "Added missing \\n to the end of #{file}"
        self.save(file, lines)
      end
    end
  end

  protected
  def root
    File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end

  def save(file, lines)
    File.open(file, "w") do |file|
      file.puts(lines)
    end
  end

  def ruby_files(&block)
    Dir["#{self.root}/**/*.{rb,ru,thor}"].each do |file|
      unless File.directory?(file) # merb.thor etc
        original = File.readlines(file)
        lines = original.each { |line| line.chomp }
        block.call(file, lines, original)
      end
    end
  end
end
