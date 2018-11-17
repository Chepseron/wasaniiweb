class AddColumnCenteredTextToSliderImages < ActiveRecord::Migration[5.0]
  def change
    add_column :slider_images, :centered_content, :text
  end
end
