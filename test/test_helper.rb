require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::RcovFormatter,
  SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_as(user)
    session[:user_id] = users(user).id
  end

  def basic_login_as(user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic
      .encode_credentials(users(user).name, 'secret')
  end

  def request_login_as(user)
    post_via_redirect login_url, name: users(user).name, password: 'secret'
    assert_response :success
  end

  def logout
    session.delete :user_id
  end

  def setup
    login_as :one if defined? session
  end
end
