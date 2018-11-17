class AddDurationColumnToLifeEvents < ActiveRecord::Migration[5.0]
  def up
    add_column :life_events, :duration, :string
  end

  def down
    remove_column :life_events, :duration
  end
end
