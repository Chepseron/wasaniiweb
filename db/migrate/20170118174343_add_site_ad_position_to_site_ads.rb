class AddSiteAdPositionToSiteAds < ActiveRecord::Migration[5.0]
  def change
    add_column :site_ads, :site_ad_position_id, :integer
  end
end
