require 'test_helper'

class Admin::AdminSignInHappyPathTest < Minitest::Capybara::Spec
  describe "the signin process" do
    it "signs_in an exisiting admin" do
      visit admin_root_path
      fill_in 'Email', with: 'hawkeye@marvelcomics.com'
      fill_in 'Password', with: 'password'
      click_button 'Login'
      assert page.current_path ==  admin_dashboard_path
    end

    it "does not sign in a non-existant admin" do
      visit admin_root_path
      fill_in 'Email', with: 'hulk@marvelcomics.com'
      fill_in 'Password', with: 'password'
      click_button 'Login'

      assert page.current_path !=  admin_dashboard_path
    end
  end
end
