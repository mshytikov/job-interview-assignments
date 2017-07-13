json.array!(@campaign_banners) do |campaign_banner|
  json.extract! campaign_banner, :id, :campaign_id, :banner_id, :weight
  json.url campaign_banner_url(campaign_banner, format: :json)
end
