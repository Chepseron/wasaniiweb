require 'test_helper'

class SignUpHappyPathTest < Minitest::Capybara::Spec
  describe "the signup process" do
    it "signs me up" do
      visit :signup

      fill_in 'user_first_name', with: 'St John'
      fill_in 'user_last_name', with: 'Allerdyce'
      fill_in 'user_email', with: 'pyro@marvelcomics.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      fill_in :user_birthday, with: 21.years.ago
      select 'Kenya', from: :user_country
      click_button 'Create User'
      assert page.has_content? 'Please confirm your email address to continue.'
    end
  end
end
