json.array!(@artists) do |artist|
  json.extract! artist, :id, :profile_name, :name, :sex, :birthday, :country_of_birth, :profile_pic_uid, :industry_id, :speciality, :introduction, :verified, :approved, :phone, :email, :height, :weight, :bust, :hips, :parent_type, :parent_id
  json.url artist_url(artist, format: :json)
end
