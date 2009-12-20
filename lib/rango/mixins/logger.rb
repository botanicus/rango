# encoding: utf-8

module Rango
  module LoggerMixin
    # Project.logger.inspect(@posts, item)
    # Project.logger.inspect("@post" => @post)
    # @since 0.0.1
    def inspect(*args)
      if args.first.is_a?(Hash) && args.length.eql?(1)
        args.first.each do |name, value|
          self.debug("#{name}: #{value.inspect}")
        end
      else
        args = args.map { |arg| arg.inspect }
        self.debug(*args)
      end
    end
  end
end

