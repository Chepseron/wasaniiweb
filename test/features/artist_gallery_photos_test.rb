require 'test_helper'

class ArtistGalleryPhotosTest < Minitest::Capybara::Spec
	describe "an artist" do
		it "can add a gallery photo to themselves" do
			artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent

			login(user)

			visit artist_path(artist)

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
