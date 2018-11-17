class CreateJoinTableLifeEventPhotoArts < ActiveRecord::Migration[5.0]
  def change
    create_join_table :life_events, :photo_arts do |t|
      # t.index [:life_event_id, :photo_art_id]
      # t.index [:photo_art_id, :life_event_id]
    end
  end
end
