require 'test_helper'

class  BusinessPhotoArtTest < Minitest::Capybara::Spec
  describe "a business" do
    it "can add a photo/art" do
      business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)

      visit business_path(business)

      assert page.has_link? "Add A Photo/Art"
      click_link "Add A Photo/Art"
      assert page.has_content? "New Photo/Art"

      fill_in 'photo_art_name', with: "Captain Marvel"
      select 23, from: :photo_art_date_3i
      select 'November', from: :photo_art_date_2i
      select 2015, from: :photo_art_date_1i
      fill_in 'photo_art_description', with: "Ms. Marvel's current powers include flight, enhanced strength, durability and the ability to shoot concussive energy bursts from her hands."
      attach_file 'photo_art_image', './test/attachments/blue-pools.jpg'
      select 'Kenya', from: :photo_art_country

      click_button "Create Photo/Art"

      assert page.has_content? "photoArts#show"
    end
  end
end
