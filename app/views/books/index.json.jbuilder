json.array!(@books) do |book|
  json.extract! book, :id, :title, :cover_pic_uid, :intro_text, :summary, :parent_id, :parent_type, :country
  json.url book_url(book, format: :json)
end
