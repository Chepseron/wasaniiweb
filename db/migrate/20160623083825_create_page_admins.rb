class CreatePageAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :page_admins, :id => false do |t|
      t.integer :user_id
      t.integer :page_id
      t.string :page_type

      t.index [:user_id, :page_id]
      t.index [:page_id, :user_id]
    end
  end
end
