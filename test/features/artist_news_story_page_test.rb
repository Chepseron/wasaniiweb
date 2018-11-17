require 'test_helper'

class  ArtistNewsStoryPageTest < Minitest::Capybara::Spec
  describe "an artist " do
    it "can add a news story page" do
      artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent

      login(user)

      visit artist_path(artist)

      assert page.has_link? 'Add A News Story'
      click_link 'Add A News Story'
      assert page.has_content? 'New News story'

      fill_in 'news_story_title', with: 'Marvel Con'
      select 23, from: :news_story_date_3i
      select 'November', from: :news_story_date_2i
      select 1986, from: :news_story_date_1i
      fill_in 'news_story_content', with: 'This is an event that is held annually for marvel enthusia
      various stake holders alike. Important announcements and developments about different marvel franchises.'

      click_button 'Create News Story'

      assert page.has_content? "News_story#show"
    end
  end

  it 'can add gallery photos to a news story' do
    artist = Artist.find_by(profile_name: 'Daredevil')
    user = artist.parent
    news_story = artist.news_stories.first

    login(user)
    visit edit_news_story_path(news_story)

		assert page.has_link? "Add A photo to gallery"
		click_link "Add A photo to gallery"
		assert page.has_content? "New Gallery Photo"

		attach_file :gallery_photo_image, './test/attachments/blue-pools.jpg'
    fill_in :gallery_photo_caption, with: "Me and Mona Lisa colling out..."

		click_button "Create Gallery photo"

		assert page.has_content? "Gallery Photo...."
  end
end
