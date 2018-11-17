class CreateSiteAdPositions < ActiveRecord::Migration[5.0]
  def up
    create_table :site_ad_positions do |t|
      t.string :name

      t.timestamps
    end

    %w(
      sidebar_ad_1 sidebar_ad_2 sidebar_ad_3
      songs_ad_1 songs_ad_2
      photo_arts_ad_1 photo_arts_ad_2
      artists_ad_1 artists_ad_2
      books_ad_1 books_ad_2
      productions_ad_1 productions_ad_2
      businesses_ad_1 businesses_ad_2
      events_ad_1 events_ad_2
    ).each do |name|
      SiteAdPosition.create!({name: name})
    end
  end

  def down
    drop_table :site_ad_positions
  end
end
