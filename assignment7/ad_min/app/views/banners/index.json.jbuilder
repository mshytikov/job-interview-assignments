json.array!(@banners) do |banner|
  json.extract! banner, :id, :name, :image
  json.url banner_url(banner, format: :json)
end
