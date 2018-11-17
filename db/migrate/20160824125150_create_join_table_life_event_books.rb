class CreateJoinTableLifeEventBooks < ActiveRecord::Migration[5.0]
  def change
    create_join_table :life_events, :books do |t|
      # t.index [:life_event_id, :book_id]
      # t.index [:book_id, :life_event_id]
    end
  end
end
