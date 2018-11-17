class AddInvitationTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :invitation_token, :string
  end
end
