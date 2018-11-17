require 'test_helper'

class ArtistLinkTest < Minitest::Capybara::Spec
  describe "an artist" do
    it "can add a link" do
      artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent
      login(user)

      visit artist_path(artist)

      assert page.has_link? 'Add A Link'
      click_link 'Add A Link'
      assert page.has_content? 'New link'

      fill_in 'link_url', with: "https://www.facebook.com/"

      click_button "Create Link"

      assert page.has_content? "Link was successfully created."
    end
  end
end
