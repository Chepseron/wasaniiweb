require 'test_helper'

class ArtistBlogTest < Minitest::Capybara::Spec
  describe "an artist" do
    it "can add a blog" do
      artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent

      login(user)

      visit artist_path(artist)

      assert page.has_link? "Add A Blog Entry"
      click_link "Add A Blog Entry"
      assert page.has_content? "New blog"

      fill_in 'blog_title', with: "Jurgen Klopp"
      fill_in 'blog_content', with: "Klopp spent most of his 15-year playing career at Mainz 05,
       before going on to become their longest-serving manager from 2001 to 2008,
       during which time they achieved promotion to the Bundesliga.
       In 2008, Klopp joined Borussia Dortmund, leading them to back-to-back Bundesliga wins in 2011 and 2012,
        . He became manager of Liverpool in October 2015."

      click_button "Create Blog"

      assert page.has_content? "blog#show"
    end
  end
end
