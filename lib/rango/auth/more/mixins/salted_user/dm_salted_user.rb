class Rango::Authentication
  module Mixins
    module SaltedUser
      module DMClassMethods
        def self.extended(base)
          base.class_eval do
            property :crypted_password, String
            property :salt, String
            validates_present      :password, if: lambda { |m| m.password_required? }
            validates_is_confirmed :password, if: lambda { |m| m.password_required? }
            before :save, :encrypt_password
          end
        end

        def authenticate(login, password)
          @u = first(Rango::Authentication::Strategies::Basic::Base.login_param => login)
          @u && @u.authenticated?(password) ? @u : nil
        end
      end
    end
  end
end
