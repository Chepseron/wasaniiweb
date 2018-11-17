class CreateArtistSpecialities < ActiveRecord::Migration[5.0]
  def up
    create_table :artist_specialities do |t|
      t.string :name
      t.integer :industry_id

      t.timestamps
    end

    ["Musician", "Music Group", "Poet", "Songwriter", "Dancer", "Dance Group", "Producer", "Performing Arts", "Entertainer"].sort.each do |name|
      industry = Industry.find_by_name('Music')
      industry.artist_specialities.create! name: name
    end

    ["Actor/Actress", "Producer", "Director", "Camera Operator", "Post Production", "Film Crew", "TV Personality", "Comedian"].sort.each do |name|
      industry = Industry.find_by_name('Film, TV and Theater')
      industry.artist_specialities.create! name: name
    end

    ["Model", "Designer", "Makeup Artist"].sort.each do |name|
      industry = Industry.find_by_name('Fashion')
      industry.artist_specialities.create! name: name
    end

    ["Photographer", "Painter", "Sculptor", "Cartoonist", "Digital Art", "3D"].sort.each do |name|
      industry = Industry.find_by_name('Art and Design')
      industry.artist_specialities.create! name: name
    end

    ["Author", "Writer", "Blogger", "Journalist"].sort.each do |name|
      industry = Industry.find_by_name('Literature')
      industry.artist_specialities.create! name: name
    end
  end

  def down
    drop_table :artist_specialities
  end
end












