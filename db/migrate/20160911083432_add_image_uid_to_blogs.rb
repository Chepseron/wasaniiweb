class AddImageUidToBlogs < ActiveRecord::Migration[5.0]
  def change
    add_column :blogs, :image_uid, :string
  end
end
