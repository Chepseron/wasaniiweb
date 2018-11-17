# == Schema Information
#
# Table name: site_ads
#
#  id                  :integer          not null, primary key
#  name                :string
#  image_uid           :string
#  script              :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  site_ad_position_id :integer
#  active              :boolean          default(TRUE)
#

require 'test_helper'

class SiteAdTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
