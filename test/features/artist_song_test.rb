require 'test_helper'

class ArtistSongTest < Minitest::Capybara::Spec
	describe "an artist" do
		it "can add a song entity" do
			artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent
      login(user)

			visit artist_path(artist)

			assert page.has_link? "Add A Song"
	  	click_link "Add A Song"
	  	assert page.has_content? "New song"

	  	fill_in 'song_name', with: "Uber Everywhere"
	  	fill_in 'song_description', with: "I recorded that song in my kitchen. We were piped up
	  		  and it was lit. Actually, my mom was in the kitchen, too. My whole crew was there in the kitchen,
	        doing what Private Crew does, and it just came up. “Uber Everywhere” was just a random line
	        that I said and then ran with. I didn’t really feel like it was a song until a day later when
	        I listened to it and said, “Yo, this is hard. I think people are really going to mess with it."
	  	fill_in 'song_lyrics', with: "Nawfside cooling, shorty, yeah that's where I stay
			    eard you was a lame boy, get up out my face. And my ex keep calling, swear that she be in way
			    And I need a  where I lay Bad  in LA tell me that she'll make the trip
			    Shorty bad as hell, yeah, with them Uber every  where,  in my VIP
			    Canada jawn, yeah I think that from the 6"
			fill_in 'song_audio_url', with: "MyString"
			select 'Full', from: :song_audio_category_id
			fill_in 'song_video_url', with: "MyString"
      attach_file :song_image, './test/attachments/blue-pools.jpg'
  		select 23, from: :song_release_date_3i
  		select 'November', from: :song_release_date_2i
  		select 2015, from: :song_release_date_1i
			select 'Kenya', from: :song_country

			click_button "Create Song"

			assert page.has_content? 'songs#show'
		end
	end
end
