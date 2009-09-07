#!/usr/bin/env rackup -s thin -p 4000
# encoding: utf-8

# TODO: how to change environment from CLI?
require_relative "init"

use Rango::Basic

# warden authentication
# wiki.github.com/hassox/warden/setup
require "warden"

use Warden::Manager do |manager|
  manager.default_strategies :password
  # Rango::Controller has class method call which will call Rango::Controller.reroute(action),
  # for example Login.route_to(:login) which will set login action of Login controller as default
  # Internally it just rewrites env["rango.controller"] and env["rango.action"] to "Login", resp. "login"
  manager.failure_app = Login
end

# See also wiki.github.com/hassox/warden/callbacks
Warden::Manager.serialize_into_session { |user| user.id }
Warden::Manager.serialize_from_session { |key| User.get(id) }

# Go to login
Warden::Manager.before_failure do |env, opts|
  Login.route_to env, "login"
end

Warden::Strategies.add(:password) do
  def authenticate!
    User.new # TODO
  end
end
