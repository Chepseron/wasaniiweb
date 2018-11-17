class CreateSuggestedUpdates < ActiveRecord::Migration[5.0]
  def change
    create_table :suggested_updates do |t|
      t.text :content
      t.integer :parent_id
      t.string :parent_type
      t.boolean :closed

      t.timestamps
    end
  end
end
