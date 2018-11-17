class AddUrlToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :url, :string, null:true
  end
end
