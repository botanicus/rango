# encoding: utf-8

module Rango
  module ORM
    class Sequel
      def load
        Rango.dependency "sequel", gem: true
        require_relative "support"
      end

      def connect
        try_connect do |adapter, database|
          Sequel.connect("#{adapter}://#{database}")
        end
      end
    end
  end
end
