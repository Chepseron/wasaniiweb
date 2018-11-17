json.array!(@productions) do |production|
  json.extract! production, :id, :cover_picture_uid, :type_id, :name, :country, :language_id, :running_time, :release_date, :synopsis, :director_id, :production_company_id, :trailer_url, :parent_id, :parent_type
  json.url production_url(production, format: :json)
end
