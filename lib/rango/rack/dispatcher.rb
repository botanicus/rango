# coding: utf-8

require "rack"

class Rango::Dispatcher
  class << self
    def app
      Rack::Builder.new do
        use Rack::ContentLength
        use Rack::MethodOverride # _method: put etc

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
          use Rack::Static, options
        else
          Rango.logger.info("Media files are routed directly to the /")
          Rango.import("rack/middlewares/static.rb")
          use Rango::Static
        end
      
        # cookies
        use Rack::Session::Cookie, path: '/'
        #, key: 'rack.session', domain: 'foo.com', path: '/', expire_after: 2592000, secret: 'change_me'

        # use Rack::Reloader
        run Rango::Dispatcher.new
      end
    end
  end
  
  attr_reader :request
  
  # @since 0.0.2
  def call(env)
    request = Rango::Request.new(env)
    route = Project.router.find(request.path)
    return route.call(request)
  rescue Rango::HttpExceptions::Error404 => exception
    return [exception.status, exception.headers, exception.body]
  # Let other error except 404 handle rack
  # rescue Rango::HttpExceptions::HttpError => exception
  #   return [exception.status, exception.headers, exception.body]
  # rescue Exception => exception
  #   Project.logger.exception(exception)
  #   @body = ["<h1>#{exception.message}</h1>"]
  #   exception.backtrace.each do |trace|
  #     @body.push("<li>#{trace}</li>")
  #   end
  #   return ["500", headers, self.body]
  end
end
