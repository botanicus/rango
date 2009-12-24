# encoding: utf-8

module Rango
  module FiltersMixin
    def self.included(controller)
      controller.extend(ClassMethods)
    end

    # for Rango::Controller
    def process_action(method)
      self.run_filters(:before, method)
      super(method)
      self.run_filters(:after, method)
    end

    # @since 0.0.2
    def run_filters(name, method)
      # Rango.logger.debug(self.class.instance_variables)
      # #Rango.logger.inspect(name: name, method: method)
      self.class.get_filters(name).each do |filter_method, options|
        unless options[:except] && options[:except].include?(method)
          if filter_method.is_a?(Symbol) && self.respond_to?(filter_method)
            Rango.logger.info("Calling filter #{filter_method} for controller #{self}")
            self.send(filter_method)
          elsif filter_method.respond_to?(:call)
            Rango.logger.info("Calling filter #{filter_method.inspect} for controller #{self}")
            self.instance_eval(&filter_method)
          else
            Rango.logger.error("Filter #{filter_method} doesn't exists!")
          end
        end
      end
    end

    module ClassMethods
      #def inherited(subclass)
      #  subclass.before_filters = self.before_filters.dup
      #  subclass.after_filters  = self.after_filters.dup
      #end

      # @since 0.2
      def before_filters
        @@before_filters ||= Hash.new
      end

      # @since 0.2
      def after_filters
        @@after_filters ||= Hash.new
      end

      # before :login
      # before :login, actions: [:send]
      # @since 0.0.2
      def before(action = nil, options = Hash.new, &block)
        self.before_filters[action || block] = options
      end

      # @since 0.0.2
      def after(action = nil, options = Hash.new, &block)
        self.after_filters[action || block] = options
      end

      # @since 0.0.2
      def get_filters(type)
        self.send("#{type}_filters")
      end
    end
  end
end
