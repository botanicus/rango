class Rango::Authentication
  module Strategies
    # To use the password strategies, it is expected that you will provide
    # an @authenticate@ method on your user class.  This should take two parameters
    # login, and password.  It should return nil or the user object.
    module Basic

      class Base < Rango::Authentication::Strategy
        abstract!

        # Overwrite this method to customize the field
        def self.password_param
          # (Rango::Plugins.config[:auth][:password_param] || :password).to_s.to_sym
          :password
        end

        # Overwrite this method to customize the field
        def self.login_param
          # (Rango::Plugins.config[:auth][:login_param] || :login).to_s.to_sym
          :login
        end

        def password_param
          @password_param ||= Base.password_param
        end

        def login_param
          @login_param ||= Base.login_param
        end
      end
    end
  end
end
