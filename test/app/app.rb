$:.unshift File.join('..', 'lib', 'sinatra')

require 'rubygems'
require 'dm-core'
require 'sinatra' 
require 'rack-flash'
require 'sinatra/session_auth'

DataMapper.setup(:default, 'sqlite3::memory:')

class User
  include DataMapper::Resource
  include Sinatra::SessionAuth::ModelHelpers 

  property :id,              Serial
  property :login,           String
  property :salt,            String
  property :hashed_password, String
end

User.auto_migrate!

use Rack::Session::Cookie
use Rack::Flash

get "/" do
  erb "<%= flash[:notice] %><br />Public"
end

get "/protected" do
  flash[:notice] = 'You must be logged in to view this page.'
  authorize!
  erb "<%= flash[:notice] %><br />Protected"
end

get '/protected/login' do
  '<form action="/protected/login" method="post">
    <label for="login">Login</label><input id="login" type="text" size="30" name="user[login]"/>
    <label for="password">Password</label><input id="password" type="password" size="30" name="user[password]"/>
    <br/>
    <input type="submit" value="Submit" name="submit"/>
  </form>'
end

post '/protected/login' do
  if session[:user] = User.authenticate(params[:user])
    flash[:notice] = "Login succesful"
    redirect '/'
  else
    flash[:notice] = "Login failed, try again"
    redirect '/login'
  end
end

get '/protected/signup' do
  '<form action="/protected/signup" method="post">
    <label for="login">Login</label><input id="login" type="text" size="30" name="user[login]"/>
    <label for="password">Password</label><input id="password" type="password" size="30" name="user[password]"/>
    <br/>
    <input type="submit" value="Submit" name="submit"/>
  </form>'
end

post '/protected/signup' do
  if session[:user] = User.new(params[:user])
    flash[:notice] = "Your account has been created"
    redirect '/'
  else
    flash[:notice] = "Signup failed, try again"
    redirect '/login'
  end
end

get '/protected/logout' do
  logout!
  flash[:notice] = "Logged out"
  redirect '/'
end

