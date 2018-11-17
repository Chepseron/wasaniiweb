require 'test_helper'

class BusinessBlogTest < Minitest::Capybara::Spec
  describe "a business" do
    it "can add a blog" do
      business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)

      visit business_path(business)

      assert page.has_link? "Add A Blog Entry"
      click_link "Add A Blog Entry"
      assert page.has_content? "New blog"

      fill_in 'blog_title', with: "Black Panther"
      fill_in 'blog_content', with: "A new era for the Black Panther starts here! Written by MacArthur Genius and National Book Award winner TA-NEHISI COATES (Between the World and Me) and illustrated by living legend BRIAN STELFREEZE, “A Nation Under Our Feet” is a story about dramatic upheaval in Wakanda and the Black Panther’s struggle to do right by his people as their ruler. The indomitable will of Wakanda -- the famed African nation known for its vast wealth, advanced technology and warrior traditions -- has long been reflected in the will of its monarchs, the Black Panthers."

      click_button "Create Blog"

      assert page.has_content? "blog#show"
    end
  end
end
