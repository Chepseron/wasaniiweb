class RemoveEditorFromAdmins < ActiveRecord::Migration[5.0]
  def change
    remove_column :admins, :editor, :boolean
  end
end
