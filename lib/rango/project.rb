# coding: utf-8

Rango.import("settings")
Rango.import("mixins/application")

class Project
  class << self
    include Rango::ImportMixin
    include Rango::ApplicationMixin
    # @since 0.0.1
    # @return [String] String reprezentation of project root directory.
    root = attribute :root, Dir.pwd

    # @since 0.0.1
    # @return [Rango::Settings::Framework] Project settings.
    attribute :settings, Rango::Settings::Framework.new

    # @since 0.0.1
    # @return [Rango::Router] Project main router.
    attribute :router

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
  end
end
