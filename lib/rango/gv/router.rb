# encoding: utf-8

require "rango/gv"
require "rango/mini"

# get("/").to(Rango::GV.defer do |request, response|
#   if request.session[:user]
#     LandingPages.dispatcher(:registered_user)
#   else
#     LandingPages.dispatcher(:unregistered_user)
#   end
# end)
#
# - redirect in router
# - different action for iPhone vs. desktop
module Rango
  module GV
    def self.defer(&hook)
      Rango::Mini.app do |request, response|
        value = hook.call(request, response)
        if value.respond_to?(:call)
          return value.call(request.env)
        elsif value.is_a?(Array) && value.length.eql?(3)
          return value # if we use redirect
        else
          raise "Value returned from Rango::GV.defer has to be Rack response or Rack application. Returned value: #{value.inspect}"
        end
      end
    end

    # Usher has support for redirect, but Rango doesn't depend on
    # any particular router and your router might not provide this
    # functionality. In this case you can always use this generic view.
    # get("/index.php").to(Rango::GV.redirect("/"))
    def self.redirect(url, status = 301)
      Rango::Mini.app do |request, response|
        response.redirect(url, status)
        return String.new
      end
    end
  end
end
