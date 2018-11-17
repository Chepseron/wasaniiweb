class CreateJoinTableBlogsEvents < ActiveRecord::Migration[5.0]
  def change
    create_join_table :blogs, :events do |t|
      # t.index [:blog_id, :event_id]
      # t.index [:event_id, :blog_id]
    end
  end
end
