class AddCoverPicToCollectionAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :collection_albums, :cover_pic_uid, :string
  end
end
