# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  first_name               :string
#  last_name                :string
#  email                    :string
#  password_digest          :string
#  profile_image_uid        :string
#  birthday                 :date
#  country                  :string
#  slug                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  email_confirmed          :boolean
#  email_confirmation_token :string
#  sign_in_count            :integer          default(0)
#  last_signed_in           :datetime
#  authentication_token     :string
#  provider                 :string
#  uid                      :string
#  provider_image_url       :string
#  password_reset_token     :string
#  password_reset_sent_at   :datetime
#  invitation_token         :string
#  user_role_id             :integer
#  content_provider         :boolean
#  newsletter               :boolean
#  banned                   :boolean
#  privacy_accepted         :boolean
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_slug   (slug) UNIQUE
#

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should create and not persist user" do
    assert_difference('User.count') do
      post users_url, params: { user:
        {
          first_name: 'Norman',
          last_name: 'Osborn',
          email: 'green_goblin@marvelcomics.com',
          password: 'password',
          password_confirmation: 'password',
          birthday: 34.years.ago.to_date,
          country: 'KE'
        }
      }
    end

    assert_nil session['user_id']
    assert_redirected_to root_path
  end

  test "should send out email after signing up" do
    assert_difference('ActionMailer::Base.deliveries.count') do
      post users_url, params: { user:
        {
          first_name: 'Norman',
          last_name: 'Osborn',
          email: 'green_goblin@marvelcomics.com',
          password: 'password',
          password_confirmation: 'password',
          birthday: 34.years.ago.to_date,
          country: 'KE'
        }
      }
    end
  end

  test "should confirm user token for unconfirmed user" do
    id = '12abcd345fgh'
    get confirm_email_user_path(id)
    assert assigns[:user].email_confirmed?
    assert_not_nil session[:user_id]
    assert assigns[:user].sign_in_count == 1
    assert_redirected_to root_path
    #TODO: make sure it goes to dashboard
  end

  test "should not confirm user with wrong user token" do
    id = '12abcd345fgj'
    get confirm_email_user_path(id)
    assert_nil assigns[:user]
  end

  test "should send out email after signin up" do
    assert_difference('ActionMailer::Base.deliveries.count') do
      post users_url, params: { user:
        {
          first_name: 'Norman',
          last_name: 'Osborn',
          email: 'green_goblin@marvelcomics.com',
          password: 'password',
          password_confirmation: 'password',
          birthday: 34.years.ago.to_date,
          country: 'KE'
        }
      }
    end
  end

  test 'an invited user should be able to log in to see the artists they manage' do
    get "/users/#{users(:wolverine).invitation_token}/accept_admin_invitation"

    assert_redirected_to dashboard_user_path(assigns[:user])
  end

  test 'a new invited user should be logged in and asked to fill in additional details' do
    get "/users/#{users(:lukecage).invitation_token}/accept_admin_invitation"

    assert_redirected_to edit_user_path(assigns[:user])
  end
end
