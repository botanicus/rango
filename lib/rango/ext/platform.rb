# encoding: utf-8

module Rango
  class Platform
    class << self
      alias_method :equal?, :eql?
      def eql?(platform)
        !! RUBY_PLATFORM.match(/#{platform}/i)
      end

      def windows?
        eql?("win32")
      end

      def linux?
        eql?("linux")
      end

      def macosx?
        eql?("universal-darwin")
      end

      def unix?
        linux? or macosx?
      end
    end
  end
end
