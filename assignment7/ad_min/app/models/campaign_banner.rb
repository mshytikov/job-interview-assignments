class CampaignBanner < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :banner
end
