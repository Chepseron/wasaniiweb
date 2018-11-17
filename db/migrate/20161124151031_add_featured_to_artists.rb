class AddFeaturedToArtists < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :featured, :boolean
  end
end
