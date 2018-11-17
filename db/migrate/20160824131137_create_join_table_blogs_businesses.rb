class CreateJoinTableBlogsBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_join_table :blogs, :businesses do |t|
      # t.index [:blog_id, :business_id]
      # t.index [:business_id, :blog_id]
    end
  end
end
