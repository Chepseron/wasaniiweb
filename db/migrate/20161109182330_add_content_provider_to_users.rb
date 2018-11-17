class AddContentProviderToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :content_provider, :boolean
  end
end
