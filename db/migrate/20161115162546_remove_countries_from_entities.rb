class RemoveCountriesFromEntities < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :country, :string
    remove_column :songs, :country, :string
    remove_column :photo_arts, :country, :string
    remove_column :productions, :country, :string
  end
end
