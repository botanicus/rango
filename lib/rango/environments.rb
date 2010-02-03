# encoding: utf-8

# http://wiki.github.com/botanicus/rango/environments-support

module Rango
  # clever environments support
  def self.environments
    @@environments ||= {
      development: ["development"],
      testing:     ["test", "spec", "cucumber"],
      production:  ["stagging", "production"]
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
end
