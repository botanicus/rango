# encoding: utf-8

# http://wiki.github.com/botanicus/rango/environments-support

require "rubyexts/attribute"

module Rango
  class << self
    # @since 0.0.1
    # @return [String] Returns current environment name.
    attribute :environment, "development"

    # clever environments support
    attribute :development_environments, ["development"]
    attribute :testing_environments,     ["test", "spec", "cucumber"]
    attribute :production_environments,  ["stage", "production"]

    questionable(:testing)     { self.testing_environments.include?(Rango.environment) }
    questionable(:development) { self.development_environments.include?(Rango.environment) }
    questionable(:production)  { self.production_environments.include?(Rango.environment) }

    def environment?(environment)
      self.environment.eql?(environment.to_s)
    end
  end
end
