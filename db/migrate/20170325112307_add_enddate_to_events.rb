class AddEnddateToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :enddate, :date, null: true
  end
end
