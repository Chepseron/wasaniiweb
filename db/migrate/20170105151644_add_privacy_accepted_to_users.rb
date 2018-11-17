class AddPrivacyAcceptedToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :privacy_accepted, :boolean
    User.update_all(privacy_accepted: true)
  end

  def down
    remove_column :users, :privacy_accepted
  end
end
