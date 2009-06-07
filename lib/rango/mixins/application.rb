# encoding: utf-8

class Rango
  module ApplicationMixin
    include Rango::ImportMixin
    # @since 0.0.1
    # @see Path
    # @return [Path] Path reprezentation of project root directory.
    def path
      Path.new(self.root)
    end

    # @since 0.0.1
    # @return [String] Name of the project. Taken from basename of project directory.
    def name
      path.basename
    end

    # @since 0.0.1
    # @return [Rango::Logger] Logger for project related stuff.
    def logger
      @logger ||= Rango::Logger.new
    end
  end
end