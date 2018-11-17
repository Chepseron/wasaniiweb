# == Schema Information
#
# Table name: slider_images
#
#  id               :integer          not null, primary key
#  image_uid        :string
#  active           :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  left_content     :text
#  right_content    :text
#  centered_content :text
#  position         :integer
#

class SliderImage < ApplicationRecord
  validates_presence_of :image
  dragonfly_accessor :image
  validates :position, uniqueness: true

  default_scope -> {order(:position)}

  def self.active
    where(active: true)
  end

end
