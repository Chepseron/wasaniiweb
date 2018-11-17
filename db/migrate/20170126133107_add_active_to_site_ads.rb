class AddActiveToSiteAds < ActiveRecord::Migration[5.0]
  def change
    add_column :site_ads, :active, :boolean, default: true
  end
end
