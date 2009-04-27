# coding: utf-8

require "rack"

class Rango::Dispatcher
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

Rack::Builder.new do
  use Rack::ContentLength
  use Rack::MethodOverride # _method: put etc
  # use Rack::Reloader

  # TODO: MEDIA_PREFIX (rango, pupu, apache)
  # serve static files
  if Project.settings.media_prefix
    # http://rack.rubyforge.org/doc/classes/Rack/Static.html
    # use Rack::File.new(Project.settings.media_root)
    # use Rack::File, Project.settings.media_root
  else
    Rango.import("rack/middlewares/static.rb")
    use Rango::Static
  end

  use Rack::Session::Cookie, path: '/'
  #, key: 'rack.session', domain: 'foo.com', path: '/', expire_after: 2592000, secret: 'change_me'
end
