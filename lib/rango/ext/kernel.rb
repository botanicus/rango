# coding=utf-8

module Kernel
  # @since 0.0.1
  # @example
  #   try_require "term/ansicolor", "term-ansicolor"
  # @param [String] library Library to require.
  # @param [String, @optional] gemname Name of gem which contains required library. Will be used for displaying message.
  # @return [Boolean] True if require was successful, false otherwise.
  def try_require(library, gemname = library)
    begin
      require library
    rescue LoadError
      message = "Gem #{gemname} isn't installed. Run sudo gem install #{gemname}."
      if defined?(Rango.logger)
        Rango.logger.warn(message)
        return false
      else
        puts(message)
        return false
      end
    end
  end

  # @since 0.0.2
  def try_dup
    self.dup rescue self
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
end