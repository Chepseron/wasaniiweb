class AddLeftContentAndRightContentToSliderImages < ActiveRecord::Migration[5.0]
  def change
    add_column :slider_images, :left_content, :text
    add_column :slider_images, :right_content, :text
  end
end
