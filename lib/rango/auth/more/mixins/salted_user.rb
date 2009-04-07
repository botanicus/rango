require "digest/sha1"
require File.expand_path(File.dirname(__FILE__) / "..") / "strategies" / "abstract_password"

class Rango::Authentication
  module Mixins
    # This mixin provides basic salted user password encryption.
    #
    # Added properties:
    #  :crypted_password, String
    #  :salt,             String
    #
    # To use it simply require it and include it into your user class.
    #
    # class User
    #   include Rango::Authentication::Mixins::SaltedUser
    # end
    module SaltedUser
      def self.included(base)
        base.class_eval do
          attr_accessor :password, :password_confirmation

          include Rango::Authentication::Mixins::SaltedUser::InstanceMethods
          extend  Rango::Authentication::Mixins::SaltedUser::ClassMethods

          path = File.expand_path(File.dirname(__FILE__)) / "salted_user"
          if defined?(DataMapper) && DataMapper::Resource > self
            require path / "dm_salted_user"
            extend(Rango::Authentication::Mixins::SaltedUser::DMClassMethods)
          elsif defined?(ActiveRecord) && ancestors.include?(ActiveRecord::Base)
            require path / "ar_salted_user"
            extend(Rango::Authentication::Mixins::SaltedUser::ARClassMethods)
          elsif defined?(Sequel) && ancestors.include?(Sequel::Model)
            require path / "sq_salted_user"
            extend(Rango::Authentication::Mixins::SaltedUser::SQClassMethods)
          elsif defined?(RelaxDB) && ancestors.include?(RelaxDB::Document)
            require path / "relaxdb_salted_user"
            extend(Rango::Authentication::Mixins::SaltedUser::RDBClassMethods)
          end
        end
      end

      module ClassMethods
        # Encrypts some data with the salt.
        def encrypt(password, salt)
          Digest::SHA1.hexdigest("--#{salt}--#{password}--")
        end
      end

      module InstanceMethods
        def authenticated?(password)
          crypted_password == encrypt(password)
        end

        def encrypt(password)
          self.class.encrypt(password, salt)
        end

        def password_required?
          crypted_password.blank? || !password.blank?
        end

        def encrypt_password
          return if password.blank?
          self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{Rango::Authentication::Strategies::Basic::Base.login_param}--") if new_record?
          self.crypted_password = encrypt(password)
        end
      end
    end
  end
end
