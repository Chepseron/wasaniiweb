class CreateCollectionAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :collection_albums do |t|
      t.string :name
      t.text :description
      t.boolean :visible
      t.integer :parent_id
      t.string :parent_type
      t.integer :collection_type_id

      t.timestamps
    end
  end
end
