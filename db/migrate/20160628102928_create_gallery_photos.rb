class CreateGalleryPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :gallery_photos do |t|
      t.string :image_uid
      t.string :caption
      t.string :parent_type
      t.integer :parent_id

      t.timestamps
    end
  end
end
