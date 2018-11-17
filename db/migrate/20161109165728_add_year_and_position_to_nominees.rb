class AddYearAndPositionToNominees < ActiveRecord::Migration[5.0]
  def change
    add_column :nominees, :year, :string
    add_column :nominees, :rank_id, :integer
  end
end
