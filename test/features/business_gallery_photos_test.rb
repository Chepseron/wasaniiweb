require 'test_helper'

class BusinessGalleryPhotosTest < Minitest::Capybara::Spec
	describe "a business" do
		it "can add a gallery photo to themselves" do
      business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)

      visit business_path(business)

			assert page.has_link? "Add A photo to gallery"
  		click_link "Add A photo to gallery"
  		assert page.has_content? "New Gallery Photo"

  		attach_file :gallery_photo_image, './test/attachments/blue-pools.jpg'
      fill_in :gallery_photo_caption, with: "Me and Mona Lisa colling out..."

			click_button "Create Gallery photo"

			assert page.has_content? "Gallery Photo...."
		end
	end
end
