# coding: utf-8

# NOTE: we need to 
class Rango
  module Bundling
    # 1) clone git repo
    # 2) run gem build, rake gem, rake package
    # 3) install gem locally
    class GitCloneStrategy < Strategy
      attr_accessor :repo
      # @since 0.0.2
      def setup
        @repo = self.options[:git]
      end
      
      # @since 0.0.2
      def match?
        self.options.key?(:git)
      end

      # @since 0.0.2
      def run
        %x[git clone #{self.repo} #{self.sources_directory}]
      end
    end

    class GithubStrategy < GitCloneStrategy
      # @since 0.0.2
      def initialize(name, options)
        path = "git://github.com/#{path}.git"
        super(name, options.merge(git: path))
      end

      # @since 0.0.2
      def match?
        self.options.key?(:github)
      end
    end
    
    class GitSubmoduleStrategy < Strategy
      # @since 0.0.2
      def setup
        @submodule = @options[:submodule]
      end

      # @since 0.0.2
      def match?
        options.key?(:submodule)
      end
      
      # @since 0.0.2
      def run
        cmd "git submodule add #{@repo}"
        # TODO
      end
    end
    
    class GithubSubmoduleStrategy < GitSubmoduleStrategy
      # @since 0.0.2
      def initialize(name, options)
        path = "git://github.com/#{path}.git"
        super(name, options.merge(submodule: path))
      end
      
      # @since 0.0.2
      def match?
        self.options.key?(:github_submodule)
      end
    end
  end
end
