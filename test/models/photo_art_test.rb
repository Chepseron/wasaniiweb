# == Schema Information
#
# Table name: photo_arts
#
#  id          :integer          not null, primary key
#  title       :string
#  date        :date
#  description :text
#  image_uid   :string
#  parent_id   :integer
#  parent_type :string
#  aasm_state  :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_photo_arts_on_slug  (slug)
#

require 'test_helper'

class PhotoArtTest < ActiveSupport::TestCase
  test "should have necessary required validators" do
    photo_art = PhotoArt.new
    assert_not photo_art.valid?
    assert_equal [:parent, :name, :date, :description, :country, :image],
    photo_art.errors.keys
  end

	test "should save a photo_art with all fields" do
		parent = artists(:daredevil)
    	photo_art = parent.photo_arts.build({
      		name: 'Markus Zusak',
	        date: 2.years.ago.to_date,
	        description: 'Public transport in Sydney: no place like home…sometimes!',
          country: 'KE',
	        image: 'My String'
    	})

    	assert photo_art.valid?
      assert photo_art.save
	end
end
