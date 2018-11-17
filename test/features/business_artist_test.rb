require 'test_helper'

class BusinessArtistTest < Minitest::Capybara::Spec
  describe "a business" do
    it "can add an artist page" do
      business = Business.find_by_name('The Daily Bugle')
      user = business.parent
      login(user)

      visit business_path(business)

      assert page.has_link? 'Add an Artist'
      click_link 'Add an Artist'
      assert page.has_content? ''

      fill_in 'artist_profile_name', with: 'Red Skull'
      fill_in 'artist_name', with: 'Johann Shmidt'
      fill_in 'artist_contact_email', with: 'redskull@marvelcomics.com'
      fill_in 'artist_contact_phone_number', with: '+254721897778'
      select 'male', from: :artist_gender
      select 'Rwanda', from: :artist_country_of_birth
      fill_in 'artist_introduction', with: "The Red Skull is a fine unarmed
        combatant, marksman and master of disguise. He possesses a keen mind
        at military, political, corporate and subversive strategies."
      check("Film")
      click_button 'Add Artist'

      assert page.has_content? Artist.last.profile_name

    end
  end
end
