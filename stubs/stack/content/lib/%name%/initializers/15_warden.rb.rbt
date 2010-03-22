# encoding: utf-8

require "warden"

# wiki.github.com/hassox/warden/setup
# MS.rack.use Warden::Manager do |manager|
#   manager.default_strategies :password
#   manager.failure_app = Admin::Authentication.dispatcher(:login)
# end

Warden::Manager.serialize_into_session { |user|  user.email }
Warden::Manager.serialize_from_session { |email| User[email] }

# NOTE: params are provided by Rack, so we can't use params[:key]
Warden::Strategies.add(:password) do
  def valid?
    (params["email"] && ! params["email"].empty?) &&
    (params["password"] && ! params["password"].empty?)
  end

  def authenticate!
    user = User.authenticate(params["email"], params["password"])
    # user.nil? ? fail!("Could not log in") : success!(user) # standard warden way
    user.nil? ? raise(Rango::Exceptions::Unauthorized) : success!(user) # so we can rescue it from controller
  end
end
