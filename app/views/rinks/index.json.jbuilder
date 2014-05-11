json.array!(@rinks) do |rink|
  json.extract! rink, :id, :latitude, :longitude, :address, :name
  json.url rink_url(rink, format: :json)
end
