class CreateAwardCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :award_categories do |t|
      t.string :name
      t.integer :award_id
      t.boolean :accepts_entity

      t.timestamps
    end
  end
end
