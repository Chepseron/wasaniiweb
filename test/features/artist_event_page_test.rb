require 'test_helper'

class  ArtistEventPageTest < Minitest::Capybara::Spec
  describe "an artist " do
    it "can add an event page" do
      artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent

      login(user)

      visit artist_path(artist)

      assert page.has_link? 'Add An Event'
      click_link 'Add An Event'
      assert page.has_content? 'New event'

      fill_in 'event_name', with: 'Marvel Con'
      select 'Film', from: :event_type_id
      fill_in 'event_description', with: 'This is an event that is held annually for marvel enthusia
          various stake holders alike. Important announcements and developments about different marvel franchises.'
      fill_in 'event_charges', with: '500'

      select 'Oscorp', from: :event_venue_id

  		select 23, from: :event_date_3i
  		select 'November', from: :event_date_2i
  		select 2016, from: :event_date_1i

      click_button 'Create Event'

      assert page.has_content? "Events#show"
    end

    it 'can add gallery photos to an event' do
      artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent
      event = artist.events.first

      login(user)
      visit edit_event_path(event)

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
