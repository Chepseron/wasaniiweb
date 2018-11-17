class CreateJoinTableBetweenAwardsAndNewsStories < ActiveRecord::Migration[5.0]
  def change
    create_join_table :awards, :news_stories do |t|
      t.index [:award_id, :news_story_id]
      t.index [:news_story_id, :award_id]
    end
  end
end
