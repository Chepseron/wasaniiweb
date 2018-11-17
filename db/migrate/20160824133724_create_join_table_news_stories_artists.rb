class CreateJoinTableNewsStoriesArtists < ActiveRecord::Migration[5.0]
  def change
    create_join_table :news_stories, :artists do |t|
      # t.index [:news_story_id, :artist_id]
      # t.index [:artist_id, :news_story_id]
    end
  end
end
