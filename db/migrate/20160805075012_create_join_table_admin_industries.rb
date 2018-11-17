class CreateJoinTableAdminIndustries < ActiveRecord::Migration[5.0]
  def change
    create_join_table :admins, :industries do |t|
      t.index [:admin_id, :industry_id]
      t.index [:industry_id, :admin_id]
    end
  end
end
