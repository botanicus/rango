# encoding: utf-8

module Kernel
  # @since 0.0.2
  def metaclass
    class << self
      self
    end
  end

  # @since 0.0.1
  # @example
  #   try_require_gem "term/ansicolor", "term-ansicolor"
  # @param [String] library Library to require.
  # @param [String, @optional] gemname Name of gem which contains required library. Will be used for displaying message.
  # @return [Boolean] True if require was successful, false otherwise.
  def try_require_gem(library, gemname = library, options = Hash.new)
    gemname, options = library, gemname if gemname.is_a?(Hash) && options.empty?
    try_require_gem!(library, gemname, options)
  rescue LoadError
    return false
  end

  # @since 0.0.3
  def try_require_gem!(library, gemname = library, options = Hash.new)
    gemname, options = library, gemname if gemname.is_a?(Hash) && options.empty?
    require library
  rescue LoadError => exception
    message  = "Gem #{gemname} isn't installed. Run sudo gem install #{gemname}. (#{exception.inspect})"
    logger   = Rango.logger.method(options[:level] || :error)
    callable = defined?(Rango.logger) ? logger : method(:puts)
    callable.call(message)
    raise exception
  end

  # @since 0.0.3
  def require_gem_or_exit(library, gemname = library, options = Hash.new)
    gemname, options = library, gemname if gemname.is_a?(Hash) && options.empty?
    try_require_gem!(library, gemname, options)
  rescue LoadError
    exit 1
  end

  # @since 0.0.3
  def try_require(library)
    require "library"
  rescue LoadError
    return false
  end

  def command(command)
    puts command
    puts %x[#{command}]
  end
  alias_method :sh, :command

  def quiet(&block)
    old_stdout = STDOUT.dup
    STDOUT.reopen("/dev/null")
    returned = block.call
    STDOUT.reopen(old_stdout)
    return returned
  end

  def quiet!(&block)
    old_stderr = STDERR.dup
    STDERR.reopen("/dev/null", "a")
    returned = quiet(&block)
    STDERR.reopen(old_stderr)
    return returned
  end

  # for quick inspection
  # @since 0.0.2
  def puts_and_return(*args)
    puts(*args)
    return *args
  end

  # @since 0.0.2
  def p_and_return(*args)
    p(*args)
    return *args
  end

  # stolen from rails (but our definition isn't compatible)
  # rails defines try as __send__ for each objects exclude nil - nil#try returns nil
  # our try returns nil if the method doesn't exist
  #
  # Invokes the method identified by the symbol +method+, passing it any arguments
  # and/or the block specified, just like the regular Ruby <tt>Object#send</tt> does.
  #
  # *Unlike* that method however, a +NoMethodError+ exception will *not* be raised
  # and +nil+ will be returned instead, if the receiving object is a +nil+ object or NilClass.
  #
  # @example
  #
  # Without try
  #   @person && @person.name
  # or
  #   @person ? @person.name : nil
  #
  # With try
  #   @person.try(:name)
  #
  # +try+ also accepts arguments and/or a block, for the method it is trying
  #   Person.try(:find, 1)
  #   @people.try(:collect) {|p| p.name}
  def try(method, *args, &block)
    self.send(method, *args, &block) if self.respond_to?(method)
  end
end
