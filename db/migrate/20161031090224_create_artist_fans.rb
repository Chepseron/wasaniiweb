class CreateArtistFans < ActiveRecord::Migration[5.0]
  def change
    create_table :artist_fans do |t|
      t.integer :artist_id
      t.integer :user_id

      t.timestamps
    end
  end
end
