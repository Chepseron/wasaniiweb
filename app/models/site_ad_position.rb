# == Schema Information
#
# Table name: site_ad_positions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SiteAdPosition < ApplicationRecord
  has_many :site_ads
end
