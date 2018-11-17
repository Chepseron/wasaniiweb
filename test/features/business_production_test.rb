require 'test_helper'

class BusinessProductionTest < Minitest::Capybara::Spec
  describe "a business" do
    it "can add a production" do
      business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)

      visit business_path(business)

      assert page.has_link? "Add A Production"
      click_link "Add A Production"
      assert page.has_content? "New production"

      fill_in :production_name, with: "Stephen Vincent Strange "
      attach_file :production_cover_picture, './test/attachments/blue-pools.jpg'
      select 'Movie', from: :production_production_category_id
      select 'Kenya', from: :production_country
      select 'English', from: :production_language_id
      fill_in :production_running_time, with: 128
      select 23, from: :production_release_date_3i
      select 'November', from: :production_release_date_2i
      select 1997, from: :production_release_date_1i

      fill_in :production_synopsis, with: " Doctor Strange is one of the most powerful sorcerers in existence. Like most sorcerers, he draws his power from three primary sources: the invocation of powerful mystic entities or objects, the manipulation of the universe's ambient magical more"
      select 'Peyton Tucker Reed', from: :production_director_id
      select 'Marvel Studios', from: :production_production_company_id

      click_button "Create Production"

      assert page.has_content? "Production was successfully created."
    end
  end
end
