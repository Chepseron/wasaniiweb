class CreateImpressions < ActiveRecord::Migration[5.0]
  def change
    create_table :impressions do |t|
      t.integer :entity_id
      t.string :entity_type

      t.timestamps
    end
  end
end
