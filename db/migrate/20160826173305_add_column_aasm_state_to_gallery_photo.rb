class AddColumnAasmStateToGalleryPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :gallery_photos, :aasm_state, :string
  end
end
