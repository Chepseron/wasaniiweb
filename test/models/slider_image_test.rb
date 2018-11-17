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

require 'test_helper'

class SliderImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
