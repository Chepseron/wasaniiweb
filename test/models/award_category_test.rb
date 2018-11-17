# == Schema Information
#
# Table name: award_categories
#
#  id             :integer          not null, primary key
#  name           :string
#  award_id       :integer
#  accepts_entity :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#

require 'test_helper'

class AwardCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
