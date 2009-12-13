# encoding: utf-8

# stolen from rails
require 'rack/utils'

module Rango
  module Middlewares
    class Static
      FILE_METHODS = %w(GET HEAD).freeze

      # @since 0.0.2
      def initialize(app)
        @app = app
        @file_server = ::Rack::File.new(Rango.media_root)
      end

      # @since 0.0.2
      def call(env)
        path        = env['PATH_INFO'].chomp('/')
        method      = env['REQUEST_METHOD']

        prefix = Rango::Middlewares::Basic.media_prefix.chomp("/")
        prefix_regexp = Regexp.new(%r[^#{prefix}/])
        if path.match(prefix_regexp) && FILE_METHODS.include?(method)
          if file_exist?(path)
            return @file_server.call(env)
            # else
            # cached_path = directory_exist?(path) ? "#{path}/index" : path
            # cached_path += ::ActionController::Base.page_cache_extension
            #
            # if file_exist?(cached_path)
            #   env['PATH_INFO'] = cached_path
            #   return @file_server.call(env)
            # end
          end
        end

        @app.call(env)
      end

      private
      def file_exist?(path)
        full_path = File.join(@file_server.root, ::Rack::Utils.unescape(path))
        File.file?(full_path) && File.readable?(full_path)
      end

      def directory_exist?(path)
        full_path = File.join(@file_server.root, ::Rack::Utils.unescape(path))
        Dir.exist?(full_path) && File.readable?(full_path)
      end
    end
  end
end
