class CreateJoinTableBetweenUsersAndIndustries < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :industries do |t|
      t.index [:user_id, :industry_id]
      t.index [:industry_id, :user_id]
    end
  end
end
