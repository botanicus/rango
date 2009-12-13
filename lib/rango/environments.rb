# encoding: utf-8

# http://wiki.github.com/botanicus/rango/environments-support

module Rango
  # @since 0.0.1
  # @return [String] Returns current environment name.
  def self.environment
    @@environment ||= "development"
  end

  def self.environment=(environment)
    @@environment = environment
  end

  # clever environments support
  def self.environments
    @@environments ||= {
      development: ["development"],
      testing:     ["test", "spec", "cucumber"],
      production:  ["stage", "production"]
    }
  end

  def self.testing?
    self.environments[:testing].include?(Rango.environment)
  end

  def self.development?
    self.environments[:development].include?(Rango.environment)
  end

  def self.production?
    self.environments[:production].include?(Rango.environment)
  end

  def self.environment?(environment)
    self.environment.eql?(environment.to_s)
  end
end
