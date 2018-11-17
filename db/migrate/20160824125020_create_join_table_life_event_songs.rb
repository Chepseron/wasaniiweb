class CreateJoinTableLifeEventSongs < ActiveRecord::Migration[5.0]
  def change
    create_join_table :life_events, :songs do |t|
      # t.index [:life_event_id, :song_id]
      # t.index [:song_id, :life_event_id]
    end
  end
end
