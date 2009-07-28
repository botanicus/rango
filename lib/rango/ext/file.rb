# encoding: utf-8

class File
  # Append given chunks to the existing file or create new one.
  # It use <tt>IO#puts</tt> for write to given file.
  #
  # @author Botanicus
  # @since 0.0.3
  # @param [String] file Path to file. You can use <tt>~</tt>, <tt>~user</tt> or similar expressions.
  # @param [String, Object] *chunks Chunks which will be written to the file
  # @raise [Errno::ENOENT] If parent directory of given file doesn't exist
  # @raise [Errno::EACCES] If you don't have permissions to write to given file
  # @return [String] Expanded path to given file
  # @example
  #   File.append "~/.bashrc", source # => "/Users/botanicus/.bashrc"
  def self.append(file, *chunks)
    self.write(:puts, "a", file, *chunks)
  end

  # Append given chunks to the existing file or create new one.
  # It use <tt>IO#print</tt> for write to given file.
  #
  # @author Botanicus
  # @since 0.0.3
  # @param [String] file Path to file. You can use <tt>~</tt>, <tt>~user</tt> or similar expressions.
  # @param [String, Object] *chunks Chunks which will be written to the file
  # @raise [Errno::ENOENT] If parent directory of given file doesn't exist
  # @raise [Errno::EACCES] If you don't have permissions to write to given file
  # @return [String] Expanded path to given file
  # @example
  #   File.append "~/.bashrc", source # => "/Users/botanicus/.bashrc"
  def self.add(file, *chunks)
    self.write(:print, "a", file, *chunks)
  end

  # Create new file and write there given chunks.
  # It use <tt>IO#puts</tt> for write to given file.
  #
  # @author Botanicus
  # @since 0.0.3
  # @param [String] file Path to file. You can use <tt>~</tt>, <tt>~user</tt> or similar expressions.
  # @param [String, Object] *chunks Chunks which will be written to the file
  # @raise [Errno::ENOENT] If parent directory of given file doesn't exist
  # @raise [Errno::EACCES] If you don't have permissions to write to given file
  # @return [String] Expanded path to given file
  # @example
  #   File.puts "~/.bashrc", source # => "/Users/botanicus/.bashrc"
  def self.puts(file, *chunks)
    self.write(:puts, "w", file, *chunks)
  end

  # Create new file and write there given chunks.
  # It use <tt>IO#print</tt> for write to given file.
  #
  # @author Botanicus
  # @since 0.0.3
  # @param [String] file Path to file. You can use <tt>~</tt>, <tt>~user</tt> or similar expressions.
  # @param [String, Object] *chunks Chunks which will be written to the file
  # @raise [Errno::ENOENT] If parent directory of given file doesn't exist
  # @raise [Errno::EACCES] If you don't have permissions to write to given file
  # @return [String] Expanded path to given file
  # @example
  #   File.print "~/.bashrc", source # => "/Users/botanicus/.bashrc"
  def self.print(file, *chunks)
    self.write(:print, "w", file, *chunks)
  end

  # Write data to file with given method.
  #
  # @author Botanicus
  # @since 0.0.3
  # @param [String] file Path to file. You can use <tt>~</tt>, <tt>~user</tt> or similar expressions.
  # @param [String, Object] *chunks Chunks which will be written to the file
  # @raise [Errno::ENOENT] If parent directory of given file doesn't exist
  # @raise [Errno::EACCES] If you don't have permissions to write to given file
  # @return [String] Expanded path to given file
  # @example
  #   File.write :printf, "w", "~/.bashrc", "%d %04x", 123, 123 # => "/Users/botanicus/.bashrc"
  def self.write(method, mode, file, *args)
    self.expand_path(file).tap do |path|
      self.open(path, mode) { |file| file.send(method, *args) }
    end
  end
end
