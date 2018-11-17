class CreateAdminRoles < ActiveRecord::Migration[5.0]
  def up
    create_table :admin_roles do |t|
      t.string :name

      t.timestamps
    end
    ['System Administrator', 'Editor', 'Content Administrator'].each{ |name| AdminRole.create! name: name }
  end

  def down
    drop_table :admin_roles
  end
end
