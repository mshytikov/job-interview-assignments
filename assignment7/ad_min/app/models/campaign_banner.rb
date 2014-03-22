class CampaignBanner < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :banner

  validates_presence_of :campaign, :banner
  validates_uniqueness_of :banner_id, scope: :campaign_id

  delegate :image, :name, to: :banner
end
