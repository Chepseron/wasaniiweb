json.extract! site, :id, :name, :title, :content, :created_at, :updated_at
json.url site_url(site, format: :json)