class CreateJoinTableBetweenAwardsAndLifeEvents < ActiveRecord::Migration[5.0]
  def change
    create_join_table :awards, :life_events do |t|
      t.index [:award_id, :life_event_id]
      t.index [:life_event_id, :award_id]
    end
  end
end
