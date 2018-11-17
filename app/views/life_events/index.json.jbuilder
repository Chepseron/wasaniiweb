json.array!(@life_events) do |life_event|
  json.extract! life_event, :id, :date, :life_event_category_id, :description, :duration, :parent_id, :parent_type
  json.url life_event_url(life_event, format: :json)
end
