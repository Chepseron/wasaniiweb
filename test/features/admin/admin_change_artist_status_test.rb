require 'test_helper'

class Admin::AdminChangeArtistStatusTest < Minitest::Capybara::Spec
  describe "the admin user" do
    it "can approve a new artist artist" do
      admin = Admin.find_by_email('hawkeye@marvelcomics.com')
      admin_login(admin)

      assert page.has_content? 'Newly Added Profiles'

      within ".new-profiles" do
        first(:link,'view').click
      end

      click_link "Approve Artist"
      page.has_content? 'Artist was successfully approved.'
      page.has_current_path? '/admin/dashboard'
    end

    it 'can reject a new artist' do
      admin = Admin.find_by_email('hawkeye@marvelcomics.com')
      admin_login(admin)

      assert page.has_content? 'Newly Added Profiles'

      within ".new-profiles" do
        first(:link,'view').click
      end

      click_link "Reject Artist"
      page.has_content? 'Artist was successfully unpublish.'
      page.has_current_path? '/admin/dashboard'
    end
  end
end
