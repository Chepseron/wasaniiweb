class CreateProductions < ActiveRecord::Migration[5.0]
  def change
    create_table :productions do |t|
      t.string :cover_picture_uid
      t.integer :production_category_id
      t.string :title
      t.string :country
      t.integer :language_id
      t.integer :running_time
      t.date :release_date
      t.text :synopsis
      t.integer :director_id
      t.integer :production_company_id
      t.string :trailer_url
      t.integer :parent_id
      t.string :parent_type
      t.string :aasm_state
      t.string :slug

      t.timestamps
      t.index :slug
    end
  end
end
