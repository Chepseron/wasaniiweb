class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.string :cover_pic_uid
      t.text :summary
      t.integer :publishing_company_id
      t.date :publishing_date
      t.integer :parent_id
      t.string :parent_type
      t.string :country
      t.string :aasm_state
      t.string :slug

      t.timestamps
      t.index :slug
    end
  end
end
