ENV['RACK_ENV'] = "test"

require 'app/app'
require 'rack/test'
require 'webrat'

Sinatra::Application.set(
  :environment => :test,
  :run => false,
  :raise_errors => true,
  :logging => false
)

Webrat.configure do |config|
  config.mode = :rack
  config.application_port = 4567
end

module TestHelper

  def app
    # change to your app class if using the 'classy' style
    # Sinatra::Application.new
    Sinatra::Application.new
  end

  def body
    last_response.body
  end

  def status
    last_response.status
  end

  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
end

require 'test/unit'
require 'shoulda'

Test::Unit::TestCase.send(:include, TestHelper)
