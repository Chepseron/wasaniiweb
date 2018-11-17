class CreateLifeEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :life_events do |t|
      t.date :date
      t.string :title
      t.integer :life_event_category_id
      t.text   :description
      t.integer :duration_time
      t.string :duration_period
      t.integer :parent_id
      t.string :parent_type
      t.string :aasm_state
      t.string :slug

      t.timestamps
      t.index :slug
    end
  end
end
