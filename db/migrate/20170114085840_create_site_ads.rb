class CreateSiteAds < ActiveRecord::Migration[5.0]
  def change
    create_table :site_ads do |t|
      t.string :name
      t.string :image_uid
      t.text :script

      t.timestamps
    end
  end
end
