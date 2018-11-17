json.array!(@songs) do |song|
  json.extract! song, :id, :name, :descriptions, :lyrics, :audio_url, :video_url, :image_uid, :country, :parent_id, :parent_type
  json.url song_url(song, format: :json)
end
