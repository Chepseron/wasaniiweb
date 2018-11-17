json.array!(@collection_albums) do |collection_album|
  json.extract! collection_album, :id, :type_id, :name, :description, :parent_id, :parent_type
  json.url collection_album_url(collection_album, format: :json)
end
