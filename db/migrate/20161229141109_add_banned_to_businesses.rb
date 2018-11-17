class AddBannedToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :banned, :boolean
  end
end
