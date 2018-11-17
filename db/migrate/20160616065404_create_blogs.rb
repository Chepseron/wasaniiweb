class CreateBlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :content
      t.date :date
      t.integer :parent_id
      t.string :parent_type
      t.string :aasm_state
      t.string :slug

      t.timestamps
      t.index :slug
    end
  end
end
