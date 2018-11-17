class CreateJoinTableBusinessProductions < ActiveRecord::Migration[5.0]
  def change
    create_join_table :businesses, :productions do |t|
      # t.index [:business_id, :production_id]
      # t.index [:production_id, :business_id]
    end
  end
end
