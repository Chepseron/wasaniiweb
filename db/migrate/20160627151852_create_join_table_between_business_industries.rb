class CreateJoinTableBetweenBusinessIndustries < ActiveRecord::Migration[5.0]
  def change
    create_join_table :businesses, :industries do |t|
      t.index [:business_id, :industry_id]
      t.index [:industry_id, :business_id]
    end
  end
end
