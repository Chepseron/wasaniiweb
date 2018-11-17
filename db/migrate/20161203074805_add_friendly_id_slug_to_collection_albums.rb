class AddFriendlyIdSlugToCollectionAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :collection_albums, :slug, :string
    add_index :collection_albums, :slug
  end
end
