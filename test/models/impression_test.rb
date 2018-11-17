# == Schema Information
#
# Table name: impressions
#
#  id          :integer          not null, primary key
#  entity_id   :integer
#  entity_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ImpressionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
