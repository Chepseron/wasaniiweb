require 'test_helper'

class  BusinessLifeEventPageTest < Minitest::Capybara::Spec
	describe "a business" do
		it "can add a life event page" do

			business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)

	    visit business_path(business)

	    assert page.has_link? 'Add Life Event'
	    click_link 'Add Life Event'
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
	end
end
