class AddUserRoleIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_role_id, :integer
  end
end
