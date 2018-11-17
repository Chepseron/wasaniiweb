json.extract! award_category, :id, :name, :award_id, :created_at, :updated_at
json.url award_category_url(award_category, format: :json)