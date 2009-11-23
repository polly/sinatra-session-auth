require 'date'
require 'digest/sha1'

module Sinatra
  module SessionAuth
    module EncryptionHelpers
      def self.included(klass)
        klass.send(:include, InstanceMethods)
        klass.send(:extend,  ClassMethods   )
      end 

      module InstanceMethods
        def password=(pass)
          @password = pass
          self.salt = User.random_string(10) unless self.salt
          self.hashed_password = User.encrypt(@password, self.salt)
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
        unless authorized?
          flash[:notice] = 'You must be logged in to view this page.'
          redirect '/login'
        end
      end

      def logout!
        session[:user] = false
      end
    end

    def self.registered(app)
      app.helpers SessionAuth::Helpers
      app.set :views, "/views"
      app.get '/login' do
        erb :login
      end

      app.post '/login' do
        if session[:user] = User.authenticate(params[:user])
          flash[:notice] = "Login succesful"
          redirect '/'
        else
          flash[:notice] = "Login failed - Try again"
          redirect '/login'
        end
      end

      app.get '/logout' do
        logout!
        flash[:notice] = "Logged out"
        redirect '/'
      end
      
      app.get "/signup" do
        erb :signup
      end

      app.post "/signup" do
        if user = User.create(params[:user])
          session[:user] = user
          flash[:notice] = "Your account was succesfully created"
          redirect '/'
         else
           flash[:notice] = "Signup failed - Try again"
           redirect '/signup'
        end
      end
    end
  end

  register SessionAuth
end
