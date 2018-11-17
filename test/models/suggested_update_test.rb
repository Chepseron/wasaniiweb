# == Schema Information
#
# Table name: suggested_updates
#
#  id          :integer          not null, primary key
#  content     :text
#  parent_id   :integer
#  parent_type :string
#  closed      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class SuggestedUpdateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
