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

class GalleryPhoto < ApplicationRecord
  include EntityState
	belongs_to :parent, polymorphic: :true
  validates_presence_of :image

	dragonfly_accessor :image

  default_scope -> {order('created_at desc')}
  scope :published, lambda{where(:aasm_state => 'published')}

  def self.lastest
    order(:created_at).limit(10)
  end

  def self.viewable
    all.collect do |photo|
      if photo.aasm_state == 'published' && photo.aasm_state != "unpublished"
        photo
      elsif (photo.parent.is_a?(Artist) || photo.parent.is_a?(Business)) &&
        photo.parent.verified && photo.aasm_state != "unpublished"
        photo
      elsif photo.parent.respond_to?(:aasm_state) || photo.parent.aasm_state == 'published' && photo.aasm_state != "unpublished"
        photo
      end
    end.compact
  end

end
