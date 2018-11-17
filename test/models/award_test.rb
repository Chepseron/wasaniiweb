# == Schema Information
#
# Table name: awards
#
#  id          :integer          not null, primary key
#  name        :string
#  business_id :integer
#  details     :text
#  image_uid   :string
#  country     :string
#  start_year  :integer
#  industry_id :integer
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  aasm_state  :string
#
# Indexes
#
#  index_awards_on_slug  (slug) UNIQUE
#

require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
