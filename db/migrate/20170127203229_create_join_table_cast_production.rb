class CreateJoinTableCastProduction < ActiveRecord::Migration[5.0]
  def change
    create_join_table :artists, :productions do |t|
      # t.index [:artist_id, :production_id]
      # t.index [:production_id, :artist_id]
    end
  end
end
