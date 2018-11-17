require 'test_helper'

class  BusinessNewsStoryTest < Minitest::Capybara::Spec
	describe " a business" do
		it "can add a news story" do
			business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)

			visit business_path(business)

	    assert page.has_link? "Add A News Story"
			click_link "Add A News Story"
			assert page.has_content? "New News story"

			fill_in 'news_story_title', with: 'Darkseid'
      select 23, from: :news_story_date_3i
      select 'November', from: :news_story_date_2i
      select 1986, from: :news_story_date_1i
      fill_in 'news_story_content', with: 'Some villains want to increase their financial standings.
      Some want to best their enemy in battle. Others want to take over a country and a few even
      desire to rule the planet. One stands above them all. One whose ambition extends beyond simply
      conquering the world. One that doesnt want to rule humanity—but all of existence. He is Darkseid,
      and when it comes to villains in the DC Universe, it doesnt get any bigger or badder than him.'

  		click_button 'Create News Story'

  		assert page.has_content? "News_story#show"

		end
	end
end
