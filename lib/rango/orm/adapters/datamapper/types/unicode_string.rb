# encoding: utf-8

require "dm-core/type"

module DataMapper
  module Types
    class UnicodeString < DataMapper::Type
      primitive String

      def self.load(value, property)
        value.to_s.force_encoding("utf-8")
      end
    end
  end
end