# coding=utf-8

class Rango
  class Controller
    # @since 0.0.1
    # @return [Rango::Request]
    # @see Rango::Request
    attr_accessor :request
    
    # @since 0.0.1
    # @return [Hash] Hash with params from request. For example <code>{:messages => {:success => "You're logged in"}, :post => {:id => 2}}</code>
    attr_accessor :params

    # @since 0.0.1
    # @return [Rango::Logger] Logger for logging project related stuff.
    # @see Rango::Logger
    attribute :logger, Project.logger
  end
end
