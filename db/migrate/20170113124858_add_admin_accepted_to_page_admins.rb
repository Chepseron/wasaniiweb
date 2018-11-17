class AddAdminAcceptedToPageAdmins < ActiveRecord::Migration[5.0]
  def change
    add_column :page_admins, :admin_accepted, :boolean, default: false
  end
end
