# coding=utf-8

# TODO: documentation
# TODO: specs
class Rango
  class RouterStrategy
    # @since 0.0.2
    attr_accessor :request, :params, :args, :block

    # @since 0.0.2
    attribute :status, 200
    attribute :headers, Hash.new

    # @since 0.0.2
    def self.register
      # TODO: different strategies for each router
      Rango::Router.strategies.push(self)
      Rango.logger.debug("Strategy #{self} have been registered")
    end
    
    # @since 0.0.2
    def initialize(request, params, *args, &block)
      @request = request
      @params  = params || Hash.new
      @args    = args || Array.new
      @block   = block
    end
    
    def __run__(body = self.body, status = self.status, headers = self.headers)
      response = Rack::Response.new(body, self.status, self.headers)
      Rango.logger.inspect(response: response)
      return response.finish
    end
  end

  # to("Post#show", "blog/views")
  # => Post.new(request).show(*args)
  class ControllerStrategy < RouterStrategy
    # @since 0.0.1
    def match?
      self.args.length >= 2 &&
      self.args[0..1].all? { |arg| arg.is_a?(String) } &&
      ! block_given?
    end

    # @since 0.0.1
    # @version 0.0.2
    def run
      Rango.import("mvc/controller")
      file = self.args[0]
      callable = self.args[1]
      options  = self.args[2]
      # match(%r[^/$]).to("eshop/views.rb", "Static#show", template: "index")
      params = options ? self.params.merge(options) : Hash.new
      Project.import(file) if file.is_a?(String)
      args = params.map { |key, value| value }
      klass_name, method = callable.split("#")
      klass = Object.const_get(klass_name)
      # raise ControllerExpected unless klass.respond_to?(:controller_class) # Or something like that. Otherwise it's confusing when user forgot "s", Post instead of Posts etc
      rack_array = klass.run(self.request, params, method, *args)
      self.__run__(*rack_array)
    end
  end

  # to(Rango.logger.method(:debug))
  # => Rango.logger.debug(request, *args)
  class CallableStrategy < RouterStrategy
    # @since 0.0.1
    def match?
      (self.args.length.eql?(1) &&
      self.args.first.respond_to?(:call)) ||
      block_given?
    end

    # @since 0.0.1
    def run
      self.callable = self.args.first || self.block
      args = self.params.map { |key, value| value }
      self.callable.call(self.request, *args)
    end
  end
end
