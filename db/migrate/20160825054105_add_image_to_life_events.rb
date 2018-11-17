class AddImageToLifeEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :life_events, :image_uid, :string
  end
end
