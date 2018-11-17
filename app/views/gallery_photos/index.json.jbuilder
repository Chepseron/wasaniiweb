json.array!(@gallery_photos) do |gallery_photo|
  json.extract! gallery_photo, :id, :image_uid, :caption, :parent_type, :parent_id
  json.url gallery_photo_url(gallery_photo, format: :json)
end
