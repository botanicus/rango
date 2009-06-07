# coding: utf-8

require_relative "encoding"

class Rango
  class Basic
    def initialize(app)
      @app = app
    end

    def call(env)
      Rango::Middlewares::Encoding.new(@app).call(env)
      Rack::MethodOverride.new(@app).call(env) # _method: put etc

      @app.call(env)

      Rack::ContentLength.new(@app).call(env)

      # serve static files
      if Project.settings.media_prefix
        # use Rack::Static, :urls => ["/media"]
        # will serve all requests beginning with /media from the "media" folder
        # located in the current directory (ie media/*).

        # use Rack::Static, :urls => ["/css", "/images"], :root => "public"
        # will serve all requests beginning with /css or /images from the folder
        # "public" in the current directory (ie public/css/* and public/images/*)
        Rango.logger.info("Media files are available on #{Project.settings.media_prefix}")
        options = {urls: [Project.settings.media_prefix]}
        Rack::Static.new(@app, options).call(env)
      else
        Rango.logger.info("Media files are routed directly to the /")
        Rango.import("rack/middlewares/static.rb")
        Rango::Static.new(@app).call(env)
      end

      # cookies
      Rack::Session::Cookie.new(@app, path: '/').call(env)
      #, key: 'rack.session', domain: 'foo.com', path: '/', expire_after: 2592000, secret: 'change_me'
    end
    
  end
end
