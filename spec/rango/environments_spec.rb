# encoding: utf-8

require_relative "../spec_helper"
require "rango/environments"

describe "Rango environments" do
  it "should defaults to development" do
    pending "This should be part of test suite testing boot & default setup which obviously can't run in the same Ruby instance because all the requires etc are global"
    Rango.environment.should eql("development")
  end

  describe ".development?" do
    it "should be true if Rango.environment is 'development'" do
      Rango.environment = "development"
      Rango.should be_development
    end

    it "should be true if Rango.environment is included in Rango.environments[:development]" do
      Rango.environment = "foobar"
      Rango.should_not be_development
      Rango.environments[:development].push("foobar")
      Rango.should be_development
    end
  end

  describe ".production?" do
    %w{production stagging}.each do |environment|
      it "should be true if Rango.environment is '#{environment}'" do
        Rango.environment = environment
        Rango.should be_production
      end
    end

    it "should be true if Rango.environment is included in Rango.environments[:production]" do
      Rango.environment = "foobar"
      Rango.should_not be_production
      Rango.environments[:production].push("foobar")
      Rango.should be_production
    end
  end

  describe ".testing?" do
    %w{test spec cucumber}.each do |environment|
      it "should be true if Rango.environment is '#{environment}'" do
        Rango.environment = environment
        Rango.should be_testing
      end
    end

    it "should be true if Rango.environment is included in Rango.environments[:testing]" do
      Rango.environment = "foobar"
      Rango.should_not be_testing
      Rango.environments[:testing].push("foobar")
      Rango.should be_testing
    end
  end

  describe ".environment?" do
    it "should returns true if current environment is the same as the only argument" do
      Rango.environment = "development"
      Rango.environment?("development").should be_true
    end

    it "should returns false if current environment is different than the only argument" do
      Rango.environment = "production"
      Rango.environment?("development").should be_false
    end
  end
end
