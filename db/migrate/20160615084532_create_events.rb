class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :type_id
      t.text :description
      t.string :charges
      t.integer :venue_id
      t.date :date
      t.string :aasm_state
      t.integer :parent_id
      t.string :parent_type
      t.string :image_uid
      t.string :slug

      t.timestamps
      t.index :slug
    end
  end
end
