json.extract! site_ad, :id, :name, :image_uid, :script, :created_at, :updated_at
json.url site_ad_url(site_ad, format: :json)