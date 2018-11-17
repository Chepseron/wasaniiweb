require 'test_helper'

class BusinessEventTest < Minitest::Capybara::Spec
  describe " a business " do
    it "can add an event" do
      business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)

      visit business_path(business)

      assert page.has_link? 'Add An Event'
      click_link 'Add An Event'
      assert page.has_content? 'New event'

      fill_in 'event_name', with: 'Captain Cold'
      select 'Film', from: :event_type_id
      fill_in 'event_description', with: 'Cold and calculating. That’s the best way to describe Leonard Snart, and it’s how he approached the job. Get in, get out and if anybody gets in the way, deal with them. No fuss and no muss. It was simple and it worked. At least until a certain scarlet-colored speedster interfered.'
      fill_in 'event_charges', with: '500'

      select 'Oscorp', from: :event_venue_id

      select 23, from: :event_date_3i
      select 'November', from: :event_date_2i
      select 2016, from: :event_date_1i

      click_button 'Create Event'

      assert page.has_content? "Events#show"
    end
  end

  it 'can add gallery photos to an event' do
    business = Business.find_by_name('Marvel Studios')
    user = business.parent
    event = business.events.first

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
