class Rango
  class Route
    include Rango::HttpExceptions
    # %r[blog/post]
    # @since 0.0.1
    attribute :match_pattern

    # {method: "get"}
    # @since 0.0.1
    attribute :match_params, Hash.new

    # @since 0.0.1
    attribute :strategy

    # @since 0.0.1
    attribute :params, Hash.new

    # to(Rango.logger.method(:debug)), to("blog/views", "Post#show")
    # @since 0.0.1
    attribute :arguments, Array.new

    # {page: 1}
    # will be merged with params
    # @since 0.0.1
    attribute :default_params, Hash.new

    # @since 0.0.1
    attribute :block

    # TODO: full const get
    # to(Rango.logger.method(:debug))
    # => Rango.logger.debug(request, *args)
    # to("Post#show", "blog/views")
    # => Post.new(request).show(*args)
    # @since 0.0.1
    def to(*args, &block)
      self.arguments = args
      self.block = block
      return self
    end


    # @since 0.0.2
    def include(*args)
      return self
    end

    # router returns callable object ... when we call the callable, it returns Rack::Response
    # @since 0.0.2
    attr_accessor :response
    def redirect(url, options = Hash.new)
      self.response = lambda do |request|
        headers = {"Location" => url}
        Rack::Response.new(String.new, 302, headers).finish
      end
    end

    # So we can returns responses directly from route
    def call(request)
      if self.response
        self.response.call(request)
      else
        self.get_strategy(request).run
      end
    end

    # @since 0.0.1
    def get_strategy(request)
      strategy = self.find_strategy(request)
      raise(AnyStrategyMatched) unless strategy
      params = self.default_params.merge(self.params)
      strategy.new(request, params, *self.arguments, self.block)
    rescue Exception => exception # FIXME: move it on better place
      Project.logger.exception(exception)
      Project.logger.debug("strategy: #{strategy.inspect}")
      Project.logger.debug("route: #{self.inspect}")
      raise Error500.new(exception, self.params)
    end

    # @since 0.0.1
    def find_strategy(request)
      return self.strategy if self.strategy
      Router.strategies.find do |strategy|
        params = self.default_params
        strategy.new(request, params, *self.arguments, &self.block).match?
      end
    end

    # default(page: 1)
    # @since 0.0.1
    def default(params)
      self.default_params = params
    end

    # @since 0.0.1
    def match?(uri)
      data = uri.match(@match_pattern)
      unless data.nil?
        data.names.each { |argument| self.params[argument.to_sym] = data[argument] }
      end
      return data
    end
  end
end
