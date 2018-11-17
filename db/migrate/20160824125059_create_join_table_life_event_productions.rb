class CreateJoinTableLifeEventProductions < ActiveRecord::Migration[5.0]
  def change
    create_join_table :life_events, :productions do |t|
      # t.index [:life_event_id, :production_id]
      # t.index [:production_id, :life_event_id]
    end
  end
end
