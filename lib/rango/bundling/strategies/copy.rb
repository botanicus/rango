# coding: utf-8

# for early development only
class Rango
  module Bundling
    class CopyStrategy < Strategy
      # @since 0.0.2
      def setup
      end

      # @since 0.0.2
      def match?
        self.options.key?(:copy) || self.options.empty?
      end

      # @since 0.0.2
      def run
      end
    end

    class SymlinkStrategy < Strategy
      # @since 0.0.2
      def setup
      end

      # @since 0.0.2
      def match?
        self.options.key?(:symlink) || self.options.empty?
      end

      # @since 0.0.2
      def run
      end
    end
  end
end
