class Campaign < ActiveRecord::Base
  has_many :campaign_banners, dependent: :destroy

  def available_banners
    if campaign_banner_ids.empty?
      Banner.all
    else
      Banner.where('id NOT in (?)', campaign_banner_ids)
    end
  end
end
