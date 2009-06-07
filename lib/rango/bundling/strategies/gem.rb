# encoding: utf-8

# Rango.dependency "dm-core"
# Rango.dependency "term-ansicolor", as: "term/ansicolor"
# Rango.dependency "pupu", github_gem: "botanicus-pupu", as: "pupu/adapters/rango"
# Rango.dependency "dm-validations", gem: "dm-more"
class Rango
  module Bundling
    class GemStrategy < Strategy
      # @since 0.0.2
      def setup
        @gem = options[:gem]
        # Rango.dependency "dm-core", gem: true
        @gem = @name if @gem.is_a?(TrueClass)
        @version = options[:version]
      end

      # @since 0.0.2
      def match?
        self.options.key?(:gem)
      end

      def install(path = @name)
        %x[gem install #{path} -i #{gems_directory}]
      end

      # @since 0.0.2
      def run
        part = File.join(Gem.path, "cache", @gem)
        if @version
          path = "#{part}-#{@version}.gem"
        else
          path = Dir["#{part}-*.gem"].last
        end
        FileUtils.mkdir(Project.settings.gems_directory)
        self.install path
      end
    end

    class GithubGem < GemStrategy
      def initialize(name, options)
        gem = options[:github_gem]
        super(name, options.merge(gem: gem))
      end

      def install(path = @name)
        %x[gem install #{path}  -i #{gems_directory} -s http://gems.github.com]
      end

      def match?
        self.options.key?(:github_gem)
      end
    end
  end
end
