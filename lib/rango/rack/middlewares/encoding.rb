# encoding: utf-8

# rack seems to have problems with encoding, so this middleware enforce UTF-8 for all the strings in rack env
module Rango
  module Middlewares
    class Encoding
      def initialize(app, encoding = ::Encoding.default_external)
        @app = app
        @encoding = encoding
      end

      def call(env)
        env.each do |key, value|
          env[try_force_encoding(key)] = try_force_encoding(value)
        end
        return @app.call(env)
      end

      protected
      def try_force_encoding(object)
        object.respond_to?(:force_encoding) ? object.dup.force_encoding(@encoding) : object
      end
    end
  end
end
