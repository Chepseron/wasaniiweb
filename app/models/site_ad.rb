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

class SiteAd < ApplicationRecord
  belongs_to :site_ad_position
  dragonfly_accessor :image
  validates :site_ad_position, uniqueness: true

  def has_content?
    image_stored? || !script.nil?
  end

  def get_content
    if !script.blank?
      return script.html_safe
    else
      return "<img src=#{image.url} />".try(:html_safe)
    end
  end
end
