require 'test_helper'

class ArtistPhotoArtTest < Minitest::Capybara::Spec
	describe "an artist" do
		it "can add a photo/art entity" do
			artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent

			login(user)

			visit artist_path(artist)

			assert page.has_link? "Add A Photo/Art"
  		click_link "Add A Photo/Art"
  		assert page.has_content? "New Photo/Art"

  		fill_in 'photo_art_name', with: "Mona Lisa"
  		select 23, from: :photo_art_date_3i
  		select 'November', from: :photo_art_date_2i
  		select 2015, from: :photo_art_date_1i
  		fill_in :photo_art_description, with: "The Mona Lisa is a half-length portrait of a woman
        by the Italian artist Leonardo da Vinci, which has been acclaimed as he best known, the
        most visited, the most written about, the most sung about, the most parodied work of art
        in the world."
  		attach_file :photo_art_image, './test/attachments/blue-pools.jpg'
      select 'Kenya', from: :photo_art_country

			click_button "Create Photo/Art"

			assert page.has_content? "photoArts#show"
		end
	end
end
