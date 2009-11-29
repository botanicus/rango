# encoding: utf-8

require "rango"

module Rango
  class << self
    # @since 0.0.1
    # @return [String] Returns current environment name. Possibilities are +development+ or +production+.
    attribute :environment, "development"

    # clever environments support
    attribute :development_environments, ["development"]
    attribute :testing_environments, ["test", "spec", "cucumber"]
    attribute :production_environments, ["stage", "production"]

    questionable :testing,     lambda { self.testing_environments.include?(Rango.environment) }
    questionable :development, lambda { self.development_environments.include?(Rango.environment) }
    questionable :production,  lambda { self.production_environments.include?(Rango.environment) }

    def environment?(environment)
      self.environment.eql?(environment.to_s)
    end
  end
end
