class Campaign < ActiveRecord::Base
  has_many :campaign_banners, dependent: :destroy

  after_save    {|r| AdServe.save_campaign(r.id, r.ratio_random, b.ratio_weighted) }
  after_destroy {|r| AdServe.delete_campaign(r.id) }

  def available_banners
    if campaign_banner_ids.empty?
      Banner.all
    else
      Banner.where('id NOT in (?)', campaign_banner_ids)
    end
  end
end
