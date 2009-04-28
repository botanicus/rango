# coding: utf-8

require "rack"

class Rango::Dispatcher
  attr_reader :request
  def use(middleware, options = Hash.new)
    @builder.use(middleware, options)
  end

  def initialize
    @builder = Rack::Builder.new
    use Rack::ContentLength
    use Rack::MethodOverride # _method: put etc
    self.cookies
    self.static
    self.reloader
  end
  
  def cookies
    use Rack::Session::Cookie, path: '/'
    #, key: 'rack.session', domain: 'foo.com', path: '/', expire_after: 2592000, secret: 'change_me'
  end
  
  def reloader
    use Rack::Reloader
  end
  
  def static
    # serve static files
    if Project.settings.media_prefixes and not Project.settings.media_prefixes.empty?
      # http://rack.rubyforge.org/doc/classes/Rack/Static.html
      Rango.logger.info("Media files are available on #{Project.settings.media_prefixes}")
      # use Rack::File, Project.settings.media_prefixes
      use Rack::Static, urls: Project.settings.media_prefixes

      # use Rack::Static, :urls => ["/media"]
      # will serve all requests beginning with /media from the "media" folder
      # located in the current directory (ie media/*).

      # use Rack::Static, :urls => ["/css", "/images"], :root => "public"
      # will serve all requests beginning with /css or /images from the folder
      # "public" in the current directory (ie public/css/* and public/images/*)
    else
      Rango.logger.info("Media files are routed directly to the /")
      Rango.import("rack/middlewares/static.rb")
      use Rango::Static
    end
  end
  
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
