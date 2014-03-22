module CampaignBannersHelper

  # Workaround for `form_for` with nested resources.
  # I have described it here https://github.com/rails/rails/issues/14451

  def campaign_campaign_banner_path(*args)
    campaign_banner_path(*args)
  end

  def campaign_campaign_banners_path(*args)
    campaign_banners_path(*args)
  end

end
