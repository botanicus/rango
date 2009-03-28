# coding=utf-8

# TODO: documentation
# TODO: specs
class Rango
  class RouterStrategy
    def register
      # TODO: different strategies for each router
      Rango::Router.strategies.push(self)
      Rango.logger.debug("Strategy #{self} have been registered")
    end
  end

  # to("Post#show", "blog/views")
  # => Post.new(request).show(*args)
  class ControllerStrategy < RouterStrategy
    def match?(request, params, *args, &block)
      args.length.eql?(2) && args.all? { |arg| arg.is_a?(String) } && !block_given?
    end

    def run(request, params, *args, &block)
      file = args.first
      callable = args.last
      Project.import(file) if file.is_a?(String)
      args = params.map { |key, value| value }
      klass_name, method = callable.split("#")
      klass = Object.const_get(klass_name)
      controller = klass.new
      controller.request = request
      controller.params  = params
      controller.method(method).call(*args)
    end
  end

  # to(Rango.logger.method(:debug))
  # => Rango.logger.debug(request, *args)
  class CallableStrategy < RouterStrategy
    def match?(request, params, *args, &block)
      (args.length.eql?(1) && args.first.respond_to?(:call)) || block_given?
    end

    def run(request, params, *args, &block)
      callable = args.first || block
      args = params.map { |key, value| value }
      callable.call(request, *args)
    end
  end
end
