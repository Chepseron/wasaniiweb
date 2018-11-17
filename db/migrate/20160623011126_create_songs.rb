class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.text :description
      t.text :lyrics
      t.string :audio_url
      t.integer :audio_category_id
      t.string :video_url
      t.string :image_uid
      t.date :release_date
      t.string :country
      t.integer :parent_id
      t.string :parent_type
      t.string :aasm_state
      t.string :slug

      t.timestamps
      t.index :slug
    end
  end
end
