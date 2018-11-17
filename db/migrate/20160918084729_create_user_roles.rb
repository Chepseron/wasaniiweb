class CreateUserRoles < ActiveRecord::Migration[5.0]
  def up
    create_table :user_roles do |t|
      t.string :name

      t.timestamps
    end

    ['Content Administrator', 'Editor', 'System Administrator'].each{ |name| UserRole.create! name: name }
  end

  def down
    drop_table :user_roles
  end
end
