require 'test_helper'

class UserArtistHappyPathTest < Minitest::Capybara::Spec
  describe "a user" do
    it "can add an artist page" do
      user = User.find_by_email('spiderman@marvelcomics.com')
      login(user)

      assert page.has_link? 'Add Artist'
      click_link 'Add Artist'
      assert page.has_content? 'New artist'

      fill_in 'artist_profile_name', with: 'Thor'
      fill_in 'artist_name', with: 'Thor Odinson'
      fill_in 'artist_contact_email', with: 'thor@marvelcomics.com'
      fill_in 'artist_contact_phone_number', with: '+254721897778'
      attach_file :artist_profile_pic, './test/attachments/blue-pools.jpg'
      select 'male', from: :artist_gender
      select 'Rwanda', from: :artist_country_of_birth
      fill_in 'artist_introduction', with: "As the Norse God of thunder and lightning,
        Thor wields one of the greatest weapons ever made, the enchanted hammer Mjolnir.
        While others have described Thor as an over-muscled, oafish imbecile,
        he's quite smart and compassionate. He's self-assured, and he would never,
        ever stop fighting for a worthwhile cause."
      check("Film")
      click_button 'Add Artist'

      assert page.has_content? 'Artist was successfully created.'
      assert page.has_css? '.username_name'
    end

    it 'can see a list of the artists pages they manage' do
      user = Artist.first.parent
      login(user)
      click_link "Profile"
      assert page.has_content? 'My Artists'
    end

    it "can invite other existing users to manage page" do
      user = User.find_by_email('spiderman@marvelcomics.com')
      login(user)
      artist = user.artists.first

      visit artist_path(artist)
      assert page.has_link? 'Invite Page Admin'
      click_link_or_button 'Invite Page Admin'

      email = User.pluck(:email).delete_if{|email| email.eql? artist.parent.email}.first
      fill_in 'invitation_email_address', with: email
      click_button 'Invite Page Admin'

      assert page.has_css? '#notice', text: 'A new admin was successfully invited'
    end

    it 'can transfer the artists they own to another manager' do
      artist = Artist.find_by_contact_email 'daredevil@marvelcomics.com'
      user = artist.parent

      login(user)
      click_link "Profile"
      assert page.has_content? 'My Artists'
      page.first(:link,'Transfer Ownership').click
      all('#transfer_ownership_new_owner option')[1].nil?
      new_owner_name = all('#transfer_ownership_new_owner option')[1].text

      select new_owner_name, from: :transfer_ownership_new_owner

      click_button 'Transfer Ownership'

      assert page.has_content? "Ownership has been transferred to #{new_owner_name}."
    end
  end
end
