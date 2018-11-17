require 'test_helper'

class BusinessLinkTest < Minitest::Capybara::Spec
  describe "a business" do
      it "can add a link" do
        business = Business.find_by_name('The Daily Bugle')
        user = business.parent
        login(user)

        visit business_path(business)

        assert page.has_link? 'Add A Link'
        click_link 'Add A Link'
        assert page.has_content? 'New link'

        fill_in 'link_url', with: "http://steelbrain.me/"

        click_button "Create Link"

        assert page.has_content? "Link was successfully created."
      end
  end
end
