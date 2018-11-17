class CreateBusinessFans < ActiveRecord::Migration[5.0]
  def change
    create_table :business_fans do |t|
      t.integer :business_id
      t.integer :user_id

      t.timestamps
    end
  end
end
