class CreateNominees < ActiveRecord::Migration[5.0]
  def change
    create_table :nominees do |t|
      t.integer :award_category_id
      t.integer :recipient_id
      t.string :recipient_type

      t.timestamps
    end
  end
end
