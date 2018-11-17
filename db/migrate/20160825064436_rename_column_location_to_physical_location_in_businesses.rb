class RenameColumnLocationToPhysicalLocationInBusinesses < ActiveRecord::Migration[5.0]
  def change
    rename_column(:businesses, :location, :physical_location)
  end
end
