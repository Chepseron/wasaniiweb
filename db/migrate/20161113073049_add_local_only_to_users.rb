class AddLocalOnlyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :view_local_content_only, :boolean
  end
end
