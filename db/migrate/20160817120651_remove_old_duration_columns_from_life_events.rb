class RemoveOldDurationColumnsFromLifeEvents < ActiveRecord::Migration[5.0]
  def change
    remove_columns(:life_events, :duration_time, :duration_period)
  end
end
