# == Schema Information
#
# Table name: gallery_photos
#
#  id          :integer          not null, primary key
#  image_uid   :string
#  caption     :string
#  parent_type :string
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  aasm_state  :string
#

require 'test_helper'

class GalleryPhotoTest < ActiveSupport::TestCase
  test "should have the necessary required validators" do
    gallery_photo = GalleryPhoto.new
    assert_not gallery_photo.valid?
    assert_equal [:parent, :image], gallery_photo.errors.keys
  end

  test "should save with required params" do
    parent = artists(:daredevil)
    gallery_photo = parent.gallery_photos.build({
      image_uid: 'image_url',
      caption: 'this is a GREAT pic!'
    })

    assert gallery_photo.valid?
    assert gallery_photo.save
  end
end
