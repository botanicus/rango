# encoding: utf-8

require "rango/settings"
require "rango/mixins/application"
require "rango/mixins/configurable"
require "rubyexts/mixins/import"

class Project
  class << self
    include RubyExts::ImportMixin
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

    attribute :router
  end
end
