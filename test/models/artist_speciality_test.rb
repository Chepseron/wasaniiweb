# == Schema Information
#
# Table name: artist_specialities
#
#  id          :integer          not null, primary key
#  name        :string
#  industry_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ArtistSpecialityTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    artist_speciality = ArtistSpeciality.new
    assert_not artist_speciality.valid?
    assert_equal [:name], artist_speciality.errors.keys
  end

  test "should not allow duplicate names" do
    artist_speciality = ArtistSpeciality.new(name: 'Writer')
    assert_not artist_speciality.valid?
    assert_equal [:name], artist_speciality.errors.keys
    assert_equal(artist_speciality.errors.full_messages[0],"Name has already been taken")
  end

  test "should save valid artist_speciality" do
    artist_speciality = ArtistSpeciality.new(name: 'Promoter')
    assert artist_speciality.valid?
    assert artist_speciality.save
  end
end
