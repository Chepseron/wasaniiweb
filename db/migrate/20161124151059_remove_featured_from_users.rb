class RemoveFeaturedFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :featured, :boolean
  end
end
