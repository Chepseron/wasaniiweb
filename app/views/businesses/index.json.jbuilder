json.array!(@businesses) do |business|
  json.extract! business, :id, :name, :logo_uid, :location, :category_id
  json.url business_url(business, format: :json)
end
