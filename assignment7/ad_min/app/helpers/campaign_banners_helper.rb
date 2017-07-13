module CampaignBannersHelper

  # Returns available banneres for select tag

  def available_banners(campaign)
    campaign.available_banners.map do |b|
      ["#{b.id}: #{b.name}", b.id, {'data-image' => b.image.url}]
    end
  end

  # Workaround for `form_for` with nested resources.
  # I have described it here https://github.com/rails/rails/issues/14451

  def campaign_campaign_banner_path(*args)
    campaign_banner_path(*args)
  end

  def campaign_campaign_banners_path(*args)
    campaign_banners_path(*args)
  end

end
