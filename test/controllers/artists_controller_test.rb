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
#  birthday             :date
#  country_of_birth     :string
#  profile_pic_uid      :string
#  introduction         :text
#  parent_id            :integer
#  parent_type          :string
#  verified             :boolean          default(FALSE)
#  aasm_state           :string
#  slug                 :string
#  height               :string
#  weight               :string
#  bust                 :string
#  hips                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  featured             :boolean
#
# Indexes
#
#  index_artists_on_parent_id    (parent_id)
#  index_artists_on_parent_type  (parent_type)
#  index_artists_on_slug         (slug) UNIQUE
#

require 'test_helper'

class ArtistsControllerTest < ActionDispatch::IntegrationTest
  test "should not invite a page admin to be page admin" do
    assert_no_difference 'ActionMailer::Base.deliveries.count' do
      post send_admin_invitation_artist_path(artists(:daredevil)), params:
      {
        invitation:
        {
          email_address: artists(:daredevil).parent.email
        }
      }
    end
  end

  test "should invite a user to be page admin" do
    assert_difference 'ActionMailer::Base.deliveries.count' do
      post send_admin_invitation_artist_path(artists(:daredevil)), params:
      {
        invitation:
        {
          email_address: "wolverine@marvelcomics.com"
        }
      }
    end
  end

  test "should invite a non-user to be a page admin" do
    assert_difference 'ActionMailer::Base.deliveries.count' do
      post send_admin_invitation_artist_path(artists(:daredevil)), params:
      {
        invitation:
        {
          email_address: "nobody@marvelcomics.com"
        }
      }
    end
    assert_not assigns(:user).invitation_token.nil?
  end

  test "should be able to transfer ownership to another page manager" do
    artist = Artist.first
    user = artist.parent

    unless artist.managing_users.empty?
      patch transfer_ownership_artist_path(artist), params:{
        transfer_ownership: {
          new_owner: artist.managing_users.first.id
        }
      }

      assert assigns(:new_owner) == artist.managing_users.first
      assert_equal assigns(:artist).reload.parent, assigns(:new_owner)
    end
  end

end
