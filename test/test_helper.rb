ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'minitest/byebug'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
end

class Minitest::Capybara::Spec
  include Capybara::DSL ## add this line
  include Rails.application.routes.url_helpers ## add this line
  # include ActiveSupport
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

def login(user)
  visit :login
  fill_in 'sessions_email', with: user.email
  fill_in 'sessions_password', with: 'password'
  click_button 'Login'
end

def admin_login(admin)
  visit admin_root_path
  fill_in 'sessions_email', with: admin.email
  fill_in 'sessions_password', with: 'password'
  click_button 'Login'
end
