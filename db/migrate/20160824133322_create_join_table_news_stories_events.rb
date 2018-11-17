class CreateJoinTableNewsStoriesEvents < ActiveRecord::Migration[5.0]
  def change
    create_join_table :news_stories, :events do |t|
      # t.index [:news_story_id, :event_id]
      # t.index [:event_id, :news_story_id]
    end
  end
end
