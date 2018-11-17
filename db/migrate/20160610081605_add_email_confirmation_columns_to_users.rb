class AddEmailConfirmationColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_confirmed, :boolean
    add_column :users, :email_confirmation_token, :string
  end
end
