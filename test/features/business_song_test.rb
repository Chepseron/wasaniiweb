require 'test_helper'

class BusinessSongTest < Minitest::Capybara::Spec
  describe "a business" do
    it "can add a song" do
      business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)
      
			visit business_path(business)

			assert page.has_link? "Add A Song"
	  	click_link "Add A Song"
	  	assert page.has_content? "New song"

	  	fill_in 'song_name', with: "GREEN ARROW #2"
	  	fill_in 'song_description', with: "U.S. Price: $2.99AVAILABLEBuy Now"

	  	fill_in 'song_lyrics', with: "“THE DEATH AND LIFE OF OLIVER QUEEN” Chapter Two: In #2, Green Arrow is betrayed, broken and left for dead. He wakes up in a world where the once-wealthy Oliver Queen has no resources and only the faintest clue what’s happened to him. Meanwhile, in a distant land, an old ally begins a quest to help the Emerald Archer in his darkest hour. "

			fill_in 'song_audio_url', with: "MyString"
			select 'Full', from: :song_audio_category_id
			fill_in 'song_video_url', with: "MyString"
			attach_file :song_image, './test/attachments/blue-pools.jpg'
			select 'Kenya', from: :song_country

			click_button "Create Song"

			assert page.has_content? 'songs#show'
    end
  end

end
