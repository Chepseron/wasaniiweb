class AddProductionCompanyToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :production_company_id, :integer
  end
end
