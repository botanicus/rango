# encoding: utf-8

module Rango
  module ORM
    class Datamapper
      def self.models
        klasses = Array.new
        ObjectSpace.each_object(Class) do |klass|
          klasses.push(klass) if klass.included_modules.include?(DataMapper::Resource)
        end
        klasses
      end

      def load
        Rango.dependency "dm-core", gem: true
        require_relative "support"
      end

      def connect
        try_connect do |adapter, database|
          DataMapper.setup(:default, "#{adapter}://#{database}")
        end
      end
    end
  end
end
