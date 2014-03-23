class CampaignBanner < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :banner

  validates_presence_of :campaign, :banner
  validates_uniqueness_of :banner_id, scope: :campaign_id

  delegate :image, :name, to: :banner

  after_save    {|r| AdServe.save_banner(r.id, r.campaign_id, r.weight, r.image_url) }
  after_destroy {|r| AdServe.delete_banner(r.id) }
end
