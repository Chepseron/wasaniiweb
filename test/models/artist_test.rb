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

class ArtistTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    artist = Artist.new
    assert_not artist.valid?
    assert_equal [:parent, :profile_name, :name, :contact_phone_number,
      :contact_email, :gender, :country_of_birth, :introduction, :industries],
    artist.errors.keys
  end

  test "should save an artist with valid fields" do
    parent = users(:spiderman)
    artist = parent.artists.build({
      :profile_name => 'BLACK WIDOW',
      :name => 'Natasha Romanova',
      :contact_phone_number => '+254722555123',
      :contact_email => 'blackwidow@marvelcomics.com',
      :gender => 'female',
      :industries => [industries(:music), industries(:film)],
      :country_of_birth => 'U.S.S.R',
      :introduction => "known by many aliases,
        is an expert spy, athlete, and assassin.
        Trained at a young age by the KGB's infamous Red Room Academy,
        the Black Widow was formerly an enemy to the Avengers.
        She later became their ally after breaking out of the U.S.S.R.'s grasp,
        and also serves as a top S.H.I.E.L.D. agent.",
      :artist_specialities => [artist_specialities(:actor), artist_specialities(:writer)],
    })
    assert artist.valid?
    assert artist.save
    assert artist.reload.artist_specialities.count == 2
  end

  test "should not allow duplicate profile names" do
    parent = users(:spiderman)
    artist = parent.artists.build({
      profile_name: 'Daredevil',
      name: 'Matthew Michael Murdock',
      gender: 'male',
      birthday: '1988-06-14',
      country_of_birth: 'kenya',
      introduction: "Abandoned by his mother, Matt Murdock was raised by his father, boxer
      \"Battling Jack\" Murdock, in Hell's Kitchen. Realizing that rules were needed to prevent
      people from behaving badly, young Matt decided to study law; however, when he saved a man
      from an oncoming truck, it spilled a radioactive cargo that rendered Matt blind while
      enhancing his remaining senses. Under the harsh tutelage of blind martial arts master Stick,
      Matt mastered his heightened senses and became a formidable fighter.",
      contact_phone_number: '+254722555123',
      contact_email: 'daredevil@marvelcomics.com',
      :industries => [industries(:music)]
    })

      assert_not artist.valid?
      assert_equal [:profile_name], artist.errors.keys
      assert_equal artist.errors.full_messages.first, "Profile name has already been taken"
  end

  test "must choose at most 2 industries" do
    parent = users(:spiderman)
    artist = parent.artists.build({
      :profile_name => 'BLACK WIDOW',
      :name => 'Natasha Romanova',
      :contact_phone_number => '+254722555123',
      :contact_email => 'blackwidow@marvelcomics.com',
      :gender => 'female',
      :industries => [industries(:music), industries(:film), industries(:fashion)],
      :country_of_birth => 'U.S.S.R',
      :introduction => "known by many aliases,
        is an expert spy, athlete, and assassin.
        Trained at a young age by the KGB's infamous Red Room Academy,
        the Black Widow was formerly an enemy to the Avengers.
        She later became their ally after breaking out of the U.S.S.R.'s grasp,
        and also serves as a top S.H.I.E.L.D. agent."
    } )
    assert_not artist.valid?
    assert_equal artist.errors.keys, [:industries]
    assert_equal artist.errors.full_messages.first, "Industries must select 2 max"
  end

  test "is_page_admin? should return true if the parent is queried" do
    artist = artists(:daredevil)
    user = artist.parent
    assert user.is_page_admin?(artist)
  end

  test "is_page_admin? should return true if an existing user admin is queried" do
    user = users(:ironman)
    artist = artists(:daredevil)
    assert user.is_page_admin?(artist)
  end

  test "is_page_admin? should return false if a non-page admin is queried" do
    user = users(:wolverine)
    artist = artists(:daredevil)
    assert_not user.is_page_admin?(artist)
  end
end
