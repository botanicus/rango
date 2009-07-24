# encoding: utf-8

require "rango"
Rango.boot

use Rango::Middlewares::Basic

# rack-router
Rango.import("router/adapters/rack-router")

use Rack::Router do |router|
  # with(to: Twitter) do
    router.map "/:action", to: Twitter
    router.map "/login",   to: Twitter, action: :login,  name: :login
    router.map "/logout",  to: Twitter, action: :logout, name: :logout
    router.map "/signup",  to: Twitter, action: :signup, name: :signup
    router.map "/",        to: Twitter, action: :index,  name: :index
    router.map "/:id",     to: Twitter, action: :timeline, name: :timeline, conditions: {id: /^\d+$/}
  # end
end

# reload code when something changed
use Rack::Reloader

# warden authentication
# wiki.github.com/hassox/warden/setup
require "warden"

Project.import("views.rb")
use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = Twitter
end

Warden::Manager.serialize_into_session { |user| user.id }
Warden::Manager.serialize_from_session { |key| User.get(id) }

# Go to login
Warden::Manager.before_failure do |env, opts|
  Twitter.route_to env, 'login'
end

Warden::Strategies.add(:password) do
  def authenticate!
    User.new
  end
end
