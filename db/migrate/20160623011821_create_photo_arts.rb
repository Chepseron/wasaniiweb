class CreatePhotoArts < ActiveRecord::Migration[5.0]
  def change
    create_table :photo_arts do |t|
      t.string :title
      t.date :date
      t.text :description
      t.string :image_uid
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
