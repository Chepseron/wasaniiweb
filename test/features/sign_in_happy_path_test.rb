require 'test_helper'

class SignInHappyPathTest < Minitest::Capybara::Spec
  describe "the signin process" do
    it "signs_in a confirmed user" do
      visit :login
      fill_in 'Email', with: 'spiderman@marvelcomics.com'
      fill_in 'Password', with: 'password'
      click_button 'Login'

      assert page.current_path ==  dashboard_user_path(User.find_by_email('spiderman@marvelcomics.com'))
    end

    it "does not sign in a non-confirmed user" do
      visit :login
      fill_in 'Email', with: 'hulk@marvelcomics.com'
      fill_in 'Password', with: 'password'
      click_button 'Login'

      assert page.current_path !=  dashboard_user_path(User.find_by_email('hulk@marvelcomics.com'))
    end
  end
end
