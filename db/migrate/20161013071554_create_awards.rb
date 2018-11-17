class CreateAwards < ActiveRecord::Migration[5.0]
  def change
    create_table :awards do |t|
      t.string :name
      t.integer :business_id
      t.text :details
      t.string :image_uid
      t.string :country
      t.integer :start_year
      t.integer :industry_id
      t.string :slug

      t.timestamps

      t.index :slug, unique: true
    end
  end
end
