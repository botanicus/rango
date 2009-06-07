# encoding: utf-8

class Rango
  module Configurable
    # @since 0.0.1
    # @example
    #   Project.configure do
    #     self.property = "value"
    #   end
    # @yield [block] Block which will be evaluated in Project.setttings object.
    # @return [Rango::Settings::Framework] Returns project settings.
    def configure(&block)
      self.settings.instance_eval(&block)
    end

    def customize(&block)
      self.settings.instance_eval(&block)
    end
  end
end