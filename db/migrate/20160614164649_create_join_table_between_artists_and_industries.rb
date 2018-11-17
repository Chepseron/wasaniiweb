class CreateJoinTableBetweenArtistsAndIndustries < ActiveRecord::Migration[5.0]
  def change
    create_join_table :artists, :industries do |t|
      t.index [:artist_id, :industry_id]
      t.index [:industry_id, :artist_id]
    end
  end
end
