class AddFeaturedToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :featured, :boolean
  end
end
