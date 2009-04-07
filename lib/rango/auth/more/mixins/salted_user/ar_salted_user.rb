class Rango::Authentication
  module Mixins
    module SaltedUser
      module ARClassMethods
        def self.extended(base)
          base.class_eval do
            validates_presence_of     :password,                   if: :password_required?
            validates_presence_of     :password_confirmation,      if: :password_required?
            validates_confirmation_of :password,                   if: :password_required?
            before_save :encrypt_password
          end
        end

        def authenticate(login, password)
          @u = find(:first, :conditions => ["#{Rango::Authentication::Strategies::Basic::Base.login_param} = ?", login])
          @u && @u.authenticated?(password) ? @u : nil
        end
      end
    end
  end
end
