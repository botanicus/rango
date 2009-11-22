# encoding: utf-8

module Rango
  module Configurable
    # @since 0.0.1
    # @example
    #   Project.configure do
    #     self.property = "value"
    #   end
    # @yield [block] Block which will be evaluated in Project.setttings object.
    # @return [Rango::Settings::Framework] Returns project settings.
    def configure(&block)
      unless self.respond_to?(:settings)
        raise "#{self.inspect} has to respond to settings"
      end
      self.settings.instance_eval(&block)
    end
  end
end
