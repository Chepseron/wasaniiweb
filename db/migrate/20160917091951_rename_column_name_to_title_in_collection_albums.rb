class RenameColumnNameToTitleInCollectionAlbums < ActiveRecord::Migration[5.0]
  def change
    rename_column :collection_albums, :name, :title
  end
end
