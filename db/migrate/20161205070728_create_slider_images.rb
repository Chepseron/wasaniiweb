class CreateSliderImages < ActiveRecord::Migration[5.0]
  def change
    create_table :slider_images do |t|
      t.string :image_uid
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
