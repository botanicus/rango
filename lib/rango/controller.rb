class Rango
  class Controller
    # @return [Rango::Request] OpenStruct with informations about the framework. Options are: <code>root</code>.
    # @see Rango::Request
    attr_accessor :request
    
    # @return [Rango::Logger] Hash with params from request. For example <code>{:messages => {:success => "You're logged in"}, :post => {:id => 2}}</code>
    attr_accessor :params

    # @return [Rango::Logger] OpenStruct with informations about the framework. Options are: <code>root</code>.
    # @see Rango::Logger
    attribute :logger, Project.logger
  end
end
