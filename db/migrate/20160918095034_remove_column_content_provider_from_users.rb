class RemoveColumnContentProviderFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :content_provider, :boolean
  end
end
