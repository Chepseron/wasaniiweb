class CreateCollectionEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :collection_entities, :id => false do |t|
      t.integer :collection_album_id
      t.integer :entity_id
      t.string :entity_type

      t.index [:collection_album_id, :entity_id]
      t.index [:entity_id, :collection_album_id]
    end
  end
end
