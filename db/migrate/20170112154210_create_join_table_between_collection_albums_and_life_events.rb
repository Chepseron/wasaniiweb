class CreateJoinTableBetweenCollectionAlbumsAndLifeEvents < ActiveRecord::Migration[5.0]
  def change
    create_join_table :collection_albums, :life_events do |t|
      # t.index [:collection_album_id, :life_event_id]
      # t.index [:life_event_id, :collection_album_id]
    end
  end
end
