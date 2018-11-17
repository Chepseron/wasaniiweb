require 'test_helper'

class  ArtistLifeEventPageTest < Minitest::Capybara::Spec
  describe "an artist" do
    it "can add a life event page" do
      artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent

      login(user)

      visit artist_path(artist)

      assert page.has_link? 'Add A Life Event'
      click_link 'Add A Life Event'
      assert page.has_content? 'New life event'

      fill_in 'life_event_title', with: 'Marvel Con'
      fill_in 'life_event_description', with: 'This is an event that is held annually for marvel enthusiast various stake holders alike. Important announcements and developments about different marvel franchises.'
      select 'Career', from: :life_event_life_event_category_id
      select 23, from: :life_event_date_3i
      select 'November', from: :life_event_date_2i
      select 1986, from: :life_event_date_1i
      fill_in 'life_event_duration', with: '2 hours'
      click_button 'Create Life Event'

      assert page.has_content? "lifeEvents#show"
    end

    it 'can add gallery photos to a life event' do
      artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent
      life_event = artist.life_events.first

      login(user)
      visit edit_life_event_path(life_event)

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
