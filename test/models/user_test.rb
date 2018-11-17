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

class UserTest < ActiveSupport::TestCase

  test "should have the necessary required validators" do
    user = User.new

    assert_not user.valid?
    assert_equal [:first_name, :last_name, :email, :country], user.errors.keys
  end

  test 'should work with all required fields' do
    user = User.new(
        first_name: 'Norman',
        last_name: 'Osborn',
        email: 'green_goblin@marvelcomics.com',
        password: 'password',
        password_confirmation: 'password',
        birthday: 34.years.ago.to_date,
        country: 'KE'
      )
    assert user.valid?
  end

  test 'should not allow email dups' do
    user = User.new(
        first_name: 'Norman',
        last_name: 'Osborn',
        email: users(:spiderman).email,
        password: 'password',
        password_confirmation: 'password',
        birthday: 34.years.ago.to_date,
        country: 'KE'
      )

    assert_not user.valid?
    assert_equal [:email], user.errors.keys
  end

  test 'should request more info from user if first name is missing' do
    user = User.new(
        last_name: 'Osborn',
        email: 'green_goblin@marvelcomics.com',
        country: 'KE'
      )
    assert user.more_info_needed?
  end

  test 'should request more info from user if last name is missing' do
    user = User.new(
        first_name: 'Norman',
        email: 'green_goblin@marvelcomics.com',
        country: 'KE'
      )
    assert user.more_info_needed?
  end

  test 'should request more info from user if email is missing' do
    user = User.new(
        first_name: 'Norman',
        last_name: 'Osborn',
        country: 'KE'
      )
    assert user.more_info_needed?
  end

  test 'should request more info from user if country is missing' do
    user = User.new(
        first_name: 'Norman',
        last_name: 'Osborn',
        email: 'green_goblin@marvelcomics.com'
      )
    assert user.more_info_needed?
  end
end
