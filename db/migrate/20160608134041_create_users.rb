class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :profile_image_uid
      t.date :birthday
      t.string :country
      t.string :slug

      t.timestamps

      t.index :slug, unique: true
      t.index :email, unique: true
    end
  end
end
