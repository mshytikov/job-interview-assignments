json.array!(@campaigns) do |campaign|
  json.extract! campaign, :id, :name, :ratio_random, :ratio_weighted
  json.url campaign_url(campaign, format: :json)
end
