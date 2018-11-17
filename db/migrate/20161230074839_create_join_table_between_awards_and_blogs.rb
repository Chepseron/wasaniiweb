class CreateJoinTableBetweenAwardsAndBlogs < ActiveRecord::Migration[5.0]
  def change
    create_join_table :awards, :blogs do |t|
      t.index [:award_id, :blog_id]
      t.index [:blog_id, :award_id]
    end
  end
end
