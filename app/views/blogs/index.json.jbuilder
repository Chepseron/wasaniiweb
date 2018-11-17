json.array!(@blogs) do |blog|
  json.extract! blog, :id, :name, :content, :parent_id, :parent_type
  json.url blog_url(blog, format: :json)
end
