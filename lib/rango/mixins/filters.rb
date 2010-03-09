# encoding: utf-8

module Rango
  module FiltersMixin
    def self.included(controller)
      controller.extend(ClassMethods)
    end

    # for Rango::Controller
    def invoke_action(action)
      self.run_filters(:before, action)
      super(action)
      self.run_filters(:after, action)
    end

    # @since 0.0.2
    def run_filters(name, action)
      # Rango.logger.debug(self.class.instance_variables)
      # Rango.logger.inspect(name: name, action: action)
      self.class.get_filters(name).each do |filter_method, options|
        unless options[:except] && options[:except].include?(action)
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
      # If you are using your own inherited hook, you have
      # to use super here, otherwise your filters won't work!
      def inherited(subclass)
        subclass.before_filters.replace(self.before_filters)
        subclass.after_filters.replace(self.after_filters)
        super
      end

      # @since 0.2
      # we can't use class variables because they
      # are shared between parent and child classes
      def before_filters
        @before_filters ||= Hash.new
      end

      # @since 0.2
      def after_filters
        @after_filters ||= Hash.new
      end

      # before :login
      # before :login, except: [:send]
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
