class CreateAdmins < ActiveRecord::Migration[5.0]
  def up
    create_table :admins do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :editor

      t.timestamps
    end

    Admin.create! name: 'Admin Guy', email: 'admin@example.com', password: 'password', password_confirmation: 'password'
  end

  def down
    drop_table :admins
  end
end
