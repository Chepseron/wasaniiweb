# == Schema Information
#
# Table name: business_fans
#
#  id          :integer          not null, primary key
#  business_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class BusinessFanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
