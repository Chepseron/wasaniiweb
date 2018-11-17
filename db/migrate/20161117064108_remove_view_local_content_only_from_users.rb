class RemoveViewLocalContentOnlyFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :view_local_content_only, :string
  end
end
