# coding=utf-8

# TODO: documentation
# TODO: copy it's spec file
class Path
  attr_reader :absolute
  # Path.new("public/uploads")
  # Path.new("#{Merb.root}/public/uploads")
  def initialize(path)
    path = path.absolute if path.is_a?(Path) # TODO: spec it
    raise ArgumentError unless path.is_a?(String) # TODO: spec it
    # no trailing /
    path.sub!(%r{/$}, "")
    if path.match(%r{^/})
      @absolute = File.expand_path(path)
    else
      @absolute = File.expand_path(File.join(Dir.pwd, path))
    end
    unless File.exist?(@absolute)
      raise "NotExists: #{@absolute}"
    end
  end

  def relative
    path = @absolute.dup
    path[Dir.pwd + "/"] = String.new
    return path
  end
  
  def url
    path = @absolute.dup
    path[Project.settings.media_root.first] = String.new ###### HACK
  end

  def ==(another)
    raise TypeError unless another.is_a?(self.class)
    @absolute == another.absolute
  end
  alias_method :eql?, :==

  def join(*segments)
    raise ArgumentError if segments.any? { |segment| not segment.is_a?(String) }
    raise ArgumentError if segments.any? { |segment| segment.match(%r{^/}) }
    Path.new(File.join(@absolute, *segments))
  end

  def +(segment)
    raise ArgumentError unless segment.is_a?(String)
    raise ArgumentError if segment.match(%r{^/})
    Path.new("#@absolute/#{segment}")
  end

  # Dir["#{path}/*"]
  alias_method :to_s, :absolute

  def entries
    Dir["#@absolute/*"].map do |path|
      self.class.new(path)
    end
  end

  def inspect
    %{"file://#@absolute"}
  end

  def basename
    File.basename(@absolute)
  end

  # # Use instead of File.open("foo", "w")
  # def self.write(file, &block)
  #   self.open(file, "w", &block)
  # end
  #
  # # Use instead of File.open("foo", "r")
  # def self.read(file, &block)
  #   self.open(file, "r", &block)
  # end
  #
  # # Use instead of File.open("foo", "a")
  # def self.append(file, &block)
  #   self.open(file, "a", &block)
  # end
  #
  # # Use instead of File.open("foo", "w+")
  # def self.rewrite(file, &block)
  #   self.open(file, "w+", &block)
  # end
  #
  def write(&block)
    File.open(file, "w", &block)
  end

  def read(&block)
    if block_given?
      File.open(@absolute, "r", &block)
    else
      File.read(@absolute)
    end
  end

  def append(&block)
    File.open(file, "a", &block)
  end

  def rewrite(&block)
    File.open(file, "w+", &block)
  end

  # Pathname("x.html.erb").extname
  # => ".erb"
  def extension(file)
    self.to_s[/\.\w+?$/] # html.erb.
    # return @path.last.sub(/\.(\w+)$/, '\1') # dalsi moznost
  end

  def extension=(extension)
    if @path.last.match(/\./)
      return Path[self[0..-1] + @path.last.sub(/\.\w+$/, ".#{extension}")]
    else
      return @path[-1] = "#{@path.last}.#{extension}"
    end
  end

  def to_a
    return self.to_s.split("/")
  end

  def without_extension
    return self.to_s.sub(/#{extension}$/, '')
  end

  def without_extension!
    return self.to_s.sub!(/#{extension}$/, '')
  end

  # alias_method :childrens, :children
  def make_executable
    File.chmod(0755, @filename)
  end

  def make_unexecutable
    File.chmod(0644, @filename)
  end

  def run(command)
    Dir.chdir(self) do
      return %x(#{command})
    end
  end

  def exist?
    File.exist?(@absolute)
  end

  def load
    Kernel.load(@absolute)
  end

  def hidden?
    self.basename.to_s.match(/^\./).to_bool
  end

  # dir/foo/../ => dir/
  def normalize
    @filename.gsub!(/[^\/]+\/\.{2}/, "")
  end

  def empty?
    self.directory? and self.children.empty?
  end

  def md5(file)
    require 'digest/md5'
    Digest::MD5.hexdigest(File.read(file))
  end

  def self.noextension(file)
    return file.sub(/\.\w+$/, '')
  end

  def self.basename_without_extension(file)
    return File.basename(file.sub(/\.\w+$/, ''))
  end

  def self.change_extension(file, extension)
    return file.sub(/\.\w+$/, ".#{extension}")
  end
end
