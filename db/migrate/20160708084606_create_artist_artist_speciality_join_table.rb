
class CreateArtistArtistSpecialityJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :artists, :artist_specialities do |t|
      t.index [:artist_id, :artist_speciality_id], name: 'artist_index'
      t.index [:artist_speciality_id, :artist_id], name: 'artist_speciality_index'
    end
  end
end

