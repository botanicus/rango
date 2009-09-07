# encoding: utf-8

Rango.import("settings")
Rango.import("mixins/application")
Rango.import("mixins/configurable")

class Project
  class << self
    include Rango::ImportMixin
    include Rango::ApplicationMixin
    include Rango::Configurable
    # @since 0.0.1
    # @return [String] String reprezentation of project root directory.
    root = attribute :root, Dir.pwd

    # @since 0.0.1
    # @return [Rango::Settings::Framework] Project settings.
    attribute :settings, Rango::Settings::Framework.new

    # @since 0.0.5
    # @return [Rango::ORM::Adapter, NilClass] Used ORM
    attribute :orm

    def bundled?
      @bundled ||= Dir.exist?(File.join(Project.root, "gems"))
    end
  end
end
