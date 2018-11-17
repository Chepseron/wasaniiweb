class AddDateToCollectionAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :collection_albums, :album_date, :date
  end
end
