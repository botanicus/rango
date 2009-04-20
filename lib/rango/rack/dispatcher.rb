# coding: utf-8

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