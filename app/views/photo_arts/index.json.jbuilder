json.array!(@photo_arts) do |photo_art|
  json.extract! photo_art, :id, :name, :date, :description, :image_uid, :parent_id, :parent_type, :country
  json.url photo_art_url(photo_art, format: :json)
end
