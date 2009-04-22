# coding: utf-8

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
      options  = self.args[2] || Hash.new
      Project.import(file) if file.is_a?(String)
      klass_name, method = callable.split("#")
      klass = Object.full_const_get(klass_name)
      raise "Controller expected, but #{klass} seems not to be controller" unless klass.controller?
      # match(%r[^/$]).to("eshop/views.rb", "Static#show", template: "index")
      # params. vs options: params are /post/:slug, options template: "index"
      klass.run(self.request, options.merge(params), method) # should returns [status, headers, body] (See Rack::Response#finish)
    end
  end

  # to(Rango.logger.method(:debug))
  # => Rango.logger.debug(request, *args)
  class CallableStrategy < RouterStrategy
    # @since 0.0.1
    def match?
      ((self.args.length.eql?(1) &&
      self.args.first.respond_to?(:call))) ||
      self.block
    end

    # @since 0.0.1
    def run
      callable = self.args.first || self.block
      args = self.params.map { |key, value| value }
      response = Rack::Response.new
      response.instance_variable_set("@request", self.request)
      response.instance_variable_set("@args", args)
      response.instance_eval { write callable.call(@request, *@args) }
      array = response.finish
      return array
    end
  end
end
