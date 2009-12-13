# encoding: utf-8

module Kernel
  # @since 0.1.1.3
  # @example
  #   try_require "term/ansicolor"
  # @param [String] library Library to require.
  # @return [Boolean] True if require was successful, false otherwise.
  def try_require(library)
    require library
  rescue LoadError
    return false
  end

  # @example require_gem "rubyexts", "rubyexts/logger"
  def require_gem(gemname, library = gemname)
    require library
  rescue LoadError
    raise LoadError, "You have to install #{gemname}!"
  end
end
