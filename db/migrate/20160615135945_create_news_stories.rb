class CreateNewsStories < ActiveRecord::Migration[5.0]
  def change
    create_table :news_stories do |t|
      t.string :title
      t.date :date
      t.text :content
      t.string :parent_type
      t.integer :parent_id
      t.string :aasm_state
      t.string :slug

      t.timestamps
      t.index :slug
    end
  end
end
