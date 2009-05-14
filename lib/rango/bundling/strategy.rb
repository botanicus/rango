# coding: utf-8

class Rango
  module Bundling
    class << self
      attribute :strategies, Array.new
      attribute :dependencies, Array.new
    end

    class Strategy
      class << self
        # @since 0.0.2
        def register
          Rango.logger.info("Strategy #{self} registered")
          Rango::Bundling.strategies.push(self)
        end
        
        def inherited(base)
          base.register
        end

        # @since 0.0.2
        def find(name, options)
          Rango::Bundling.strategies.each do |strategy|
            strategy = strategy.new(name, options)
            return strategy if strategy.match?
          end
          return nil
        end
        
        def install
          Rango.dependencies.each(&:install)
        end
      end
      
      attr_accessor :name, :options
      def initialize(name, options)
        @name    = name
        @options = options
        self.setup if self.respond_to?(:setup)
      end
      
      def register
        Rango::Bundling.dependencies.push(self)
        return self
      end
      
      def sources_directory
        File.join(Project.settings.sources_directory, @name)
      end
      
      def gems_directory
        Project.settings.gems_directory
      end
      
      def activate_gem
        args = [@options[:gem]]
        version = @version || @options[:version]
        args.push(version) if version
        gem *args
      end

      def load
        # self.activate_gem if @options[:gem]
        require (@options[:as] || @name)
      end
    end
    
    class RequireStrategy < Strategy
      # @since 0.0.2
      def match?
        self.options.empty?
      end

      # @since 0.0.2
      def run
        Rango.logger.error("This dependency can't be bundled. Please provide more options.")
      end
      
      def load
        require @name
      end
    end
  end
end
