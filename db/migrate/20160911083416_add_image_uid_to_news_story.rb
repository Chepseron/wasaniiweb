class AddImageUidToNewsStory < ActiveRecord::Migration[5.0]
  def change
    add_column :news_stories, :image_uid, :string
  end
end
