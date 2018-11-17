# == Schema Information
#
# Table name: nominees
#
#  id                :integer          not null, primary key
#  award_category_id :integer
#  recipient_id      :integer
#  recipient_type    :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  year              :string
#  rank_id           :integer          default(4)
#

require 'test_helper'

class NomineeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
