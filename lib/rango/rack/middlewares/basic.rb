# encoding: utf-8

require_relative "encoding"

module Rango
  module RackDebug
    def call(env)
      Rango.logger.info("Middleware #{self.class} executed")
      returned = super(env)
      Rango.logger.info("Middleware #{self.class} finished")
      returned
    end
  end
end


module Rango
  module Middlewares
    class Basic
      attr_accessor :before, :after
      def initialize(app, &block)
        @app = app.extend(Rango::RackDebug)

        #, key: 'rack.session', domain: 'foo.com', path: '/', expire_after: 2592000, secret: 'change_me'
        self.before = [Rango::Middlewares::Encoding, Rack::MethodOverride, [Rack::Session::Cookie, path: '/']]
        self.after = [Rack::ContentType, Rack::ContentLength, Rango::Middlewares::Encoding, Rack::Head]

        self.static_files_serving
        
        block.call(self) if block_given?
        # use Rango::Middlewares::Basic do |middleware|
        #   middleware.before.push MyMiddleware
        # end
      end
      
      def call(env)
        # Matryoshka principle
        # MethodOverride.new(Encoding.new(@app))
        middlewares = self.before + self.after
        @app = middlewares.inject(@app) do |app, klass|
          args = Array.new
          if klass.is_a?(Array)
            klass, args = klass
            args = [args]
            Rango.logger.debug("#{klass}.new(app, #{args.map { |arg| arg.inspect }.join(", ")})")
          else
            Rango.logger.debug("#{klass}.new(app)")
          end
          klass.new(app, *args).extend(RackDebug)
        end
        @app.call(env)
      end

      def static_files_serving
        if Project.settings.media_prefix.empty?
          Rango.logger.info("Media files are routed directly to the /")
          require "rango/rack/middlewares/static"
          self.before.unshift Rango::Middlewares::Static
        else
          # use Rack::Static, :urls => ["/media"]
          # will serve all requests beginning with /media from the "media" folder
          # located in the current directory (ie media/*).

          # use Rack::Static, :urls => ["/css", "/images"], :root => "public"
          # will serve all requests beginning with /css or /images from the folder
          # "public" in the current directory (ie public/css/* and public/images/*)
          Rango.logger.info("Media files are available on #{Project.settings.media_prefix}")
          options = {urls: [Project.settings.media_prefix]}
          self.before.unshift [Rack::Static, options]
        end
      end
    end
  end
end
