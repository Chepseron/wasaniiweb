class AddAasmStateToCollectionAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :collection_albums, :aasm_state, :string
  end
end
