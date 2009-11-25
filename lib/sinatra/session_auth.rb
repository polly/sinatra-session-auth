require 'date'
require 'digest/sha1'

module Sinatra
  module SessionAuth
    module ModelHelpers
      def self.included(klass)
        klass.send :include, InstanceMethods
        klass.send :extend,  ClassMethods
      end 

      module InstanceMethods
        def password=(pass)
          @password = pass
          self.salt = self.class.random_string(10) unless self.salt
          self.hashed_password = self.class.encrypt(@password, self.salt)
        end
      end

      module ClassMethods
        def encrypt(pass, salt)
          Digest::SHA1.hexdigest(pass + salt)
        end

        def authenticate(args={})
          login, pass = args[:login], args[:password]
          u = self.first(:login => login)
          return nil if u.nil?
          return u if self.encrypt(pass, u.salt) == u.hashed_password
          nil
        end

        def random_string(len)
          chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
          str = ""
          1.upto(len) { |i| str << chars[rand(chars.size-1)] }
          return str
        end
      end
    end
    
    module Helpers
      def authorized?
        return true if session[:user]
      end

      def authorize!
        redirect '/protected/login' unless authorized?
      end

      def logout!
        session[:user] = false
      end
    end

    def self.registered(app)
      app.helpers SessionAuth::Helpers
    end
  end

  register SessionAuth
end
