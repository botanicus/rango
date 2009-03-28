# coding=utf-8

project_dir = ::File.dirname(__FILE__)
require ::File.join(project_dir, "rango", "lib", "rango")

Thin::Logging.debug = true
Thin::Logging.trace = true

Rango.boot(:flat => true)
Rango.import("request")
Rango.import("handler")

class Dispatcher < Rango::Handler
  def call(env)
    request  = Rango::Request.new(env)
    route    = Project.router.find(request.path)
    @body    = route.call(request)
    response = super(env)
    Project.logger.debug("Response: #{response}")
    return response
  rescue Exception => exception
    Project.logger.exception(exception)
  end
end

run Dispatcher.new

Project.configure do
  # TODO
end

Rango::CallableStrategy.new.register

Rango::Router.register do
  # TODO
end