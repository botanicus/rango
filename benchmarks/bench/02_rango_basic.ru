# encoding: utf-8

require "thin"
require "simple-logger"
require "rango/rack/middlewares/basic"

app = lambda do |env|
  content = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  [200, {}, [content]]
end

use Rango::Middlewares::Basic

Rack::Handler::Thin.run(app, Port: 4002)
