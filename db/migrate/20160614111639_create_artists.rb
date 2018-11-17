class CreateArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists do |t|
      t.string :profile_name
      t.string :name
      t.string :contact_phone_number
      t.string :contact_email
      t.string :gender
      t.date :birthday
      t.string :country_of_birth
      t.string :profile_pic_uid
      t.text :introduction
      t.integer :parent_id
      t.string :parent_type
      t.boolean :verified, default: false
      t.string :aasm_state
      t.string :slug
      t.string :height
      t.string :weight
      t.string :bust
      t.string :hips

      t.timestamps

      t.index :slug, unique: true
      t.index :parent_id
      t.index :parent_type
    end

  end
end
