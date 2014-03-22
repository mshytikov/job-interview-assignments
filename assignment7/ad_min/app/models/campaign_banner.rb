class CampaignBanner < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :banner

  validates_presence_of :campaign, :banner
end
