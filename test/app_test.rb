require 'test_helper'

class AppTest < Test::Unit::TestCase
  
  context "GET /" do
    should "not require authentication" do
      visit "/"
      assert_contain "Public"
    end
  end
  
  context "GET /protected" do
    should "require authentication" do
      visit "/protected"
      assert_equal "http://example.org/protected/login", last_request.url
    end
  end

  context "A visitor" do
    should "be able to signup for an account" do
      visit "/protected/signup" 
      fill_in "Login",    :with => "pmh"
      fill_in "Password", :with => "1234"
      click_button "Submit"
      assert_contain "Your account has been created"
    end

    should "be able to login" do
      user = User.create(:login => "pmh", :password => "1234")

      visit "/protected/login"
      fill_in "Login",    :with => "pmh"
      fill_in "Password", :with => "1234"
      click_button "Submit"
      assert_contain "Login succesful"
    end
  end
end
