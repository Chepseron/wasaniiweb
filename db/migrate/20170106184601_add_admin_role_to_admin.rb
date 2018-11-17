class AddAdminRoleToAdmin < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :admin_role_id, :integer
    add_column :admins, :deactivated, :boolean
  end
end
