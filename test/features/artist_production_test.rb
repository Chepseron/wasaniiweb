require 'test_helper'

class ArtistProductionTest < Minitest::Capybara::Spec
  describe "an artist" do
    it "can add a production" do
			artist = Artist.find_by(profile_name: 'Daredevil')
      user = artist.parent

      login(user)

      visit artist_path(artist)
      assert page.has_link? "Add A Production"
      click_link "Add A Production"
      assert page.has_content? "New production"

      fill_in :production_name, with: "Ant-Man "
      attach_file :production_cover_picture, './test/attachments/blue-pools.jpg'
      select 'Movie', from: :production_production_category_id
      select 'Kenya', from: :production_country
      select 'English', from: :production_language_id
      fill_in :production_running_time, with: 128
      select 23, from: :production_release_date_3i
      select 'November', from: :production_release_date_2i
      select 1997, from: :production_release_date_1i


      fill_in :production_synopsis, with: "In 1989, scientist Hank Pym
        resigns from S.H.I.E.L.D. after discovering their attempt to
        replicate his Ant-Man shrinking technology. Believing the technology
        is dangerous, Pym vows to hide it as long as he lives."
      select 'Peyton Tucker Reed', from: :production_director_id
      select 'Marvel Studios', from: :production_production_company_id


      click_button "Create Production"

      assert page.has_content? "Production was successfully created."
    end
  end
end
