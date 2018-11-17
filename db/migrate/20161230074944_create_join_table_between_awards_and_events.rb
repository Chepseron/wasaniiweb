class CreateJoinTableBetweenAwardsAndEvents < ActiveRecord::Migration[5.0]
  def change
    create_join_table :awards, :events do |t|
      t.index [:award_id, :event_id]
      t.index [:event_id, :award_id]
    end
  end
end
