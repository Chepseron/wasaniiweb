json.array!(@links) do |link|
  json.extract! link, :id, :url, :parent_id, :parent_type
  json.url link_url(link, format: :json)
end
