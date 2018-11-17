json.array!(@news_stories) do |news_story|
  json.extract! news_story, :id, :name, :content, :parent_type, :parent_id
  json.url news_story_url(news_story, format: :json)
end
