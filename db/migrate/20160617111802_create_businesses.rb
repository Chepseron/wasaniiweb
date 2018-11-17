class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :country
      t.string :logo_uid
      t.text :company_info
      t.float :latitude
      t.float :longitude
      t.integer :business_category_id
      t.integer :parent_id
      t.string :parent_type
      t.boolean :verified, default: false
      t.string :slug

      t.timestamps

      t.index :slug, unique: true
      t.index :parent_id
      t.index :parent_type
    end
  end
end
