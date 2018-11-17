class CreateJoinTableNewsStoriesBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_join_table :news_stories, :businesses do |t|
      # t.index [:news_story_id, :business_id]
      # t.index [:business_id, :news_story_id]
    end
  end
end
