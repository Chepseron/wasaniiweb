class AddContactColumnsToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :location, :string
    add_column :businesses, :phone_number, :string
    add_column :businesses, :email, :string
    add_column :businesses, :working_hours, :string
  end
end
