json.array!(@events) do |event|
  json.extract! event, :id, :event_name, :event_type, :event_description, :venue, :charges, :parent_id, :parent_type
  json.url event_url(event, format: :json)
end
