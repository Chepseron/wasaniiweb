class AddPositionToSliderImages < ActiveRecord::Migration[5.0]
  def change
    add_column :slider_images, :position, :integer
  end
end
