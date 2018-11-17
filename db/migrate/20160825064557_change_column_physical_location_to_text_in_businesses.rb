class ChangeColumnPhysicalLocationToTextInBusinesses < ActiveRecord::Migration[5.0]
  def change
    change_column(:businesses, :physical_location, :text)
  end
end
