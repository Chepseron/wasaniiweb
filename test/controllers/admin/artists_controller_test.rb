# == Schema Information
#
# Table name: artists
#
#  id                   :integer          not null, primary key
#  profile_name         :string
#  name                 :string
#  contact_phone_number :string
#  contact_email        :string
#  gender               :string
#  birthday        :date
#  country_of_birth     :string
#  profile_pic_uid      :string
#  introduction         :text
#  parent_id            :integer
#  parent_type          :string
#  verified             :boolean          default(FALSE)
#  aasm_state           :string           default("new_profile")
#  height               :string
#  weight               :string
#  bust                 :string
#  hips                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'test_helper'

class Admin::ArtistsControllerTest < ActionDispatch::IntegrationTest
  test "can approve a new artist profile" do
    artist = Artist.new_profile.first
    patch change_status_admin_artist_path(artist), params: {
      "status"=>"approve"
    }
    assert artist.reload.approved?
  end

  test "can reject a new artist profile" do
    artist = Artist.new_profile.first

    patch change_status_admin_artist_path(artist), params: {
      "status"=>"reject"
    }
    assert artist.reload.rejected?
  end

  test "can approve a rejected artist profile" do
    artist = Artist.rejected.first

    patch change_status_admin_artist_path(artist), params: {
      "status"=>"approve"
    }
    assert artist.reload.approved?
  end

  test "can reject an approved artist profile" do
    artist = Artist.approved.first

    patch change_status_admin_artist_path(artist), params: {
      "status"=>"reject"
    }
    assert artist.reload.rejected?
  end
end
