class CreateJoinTableBlogsArtists < ActiveRecord::Migration[5.0]
  def change
    create_join_table :blogs, :artists do |t|
      # t.index [:blog_id, :artist_id]
      # t.index [:artist_id, :blog_id]
    end
  end
end
