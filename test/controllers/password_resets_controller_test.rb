require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "should send an email to user" do
    assert_difference('ActionMailer::Base.deliveries.count') do
      post password_resets_url, params: { password_resets:
        {
          email: 'hulk@marvelcomics.com',
        }
      }
    end
  end

  test "should update params after user resets password" do
    old_password = users(:hulk).password_digest
    patch password_reset_path(users(:hulk).password_reset_token), params: {user: {
        password: 'ironman',
        password_confirmation: 'ironman'
      }
    }
    assert assigns(:user).reload.password_digest != old_password
    assert_redirected_to login_url
  end

  test "should check if email link sent redirects to password reset form" do
    get "/password_resets/#{users(:hulk).password_reset_token}/edit"

    assert_template :edit
    assert assigns[:user] == users(:hulk)
  end
end
