class Campaign < ActiveRecord::Base
  has_many :campaign_banners, dependent: :destroy

  after_save    {|r| AdServe.save_campaign(r.id, r.ratio_random, r.ratio_weighted) }
  after_destroy {|r| AdServe.delete_campaign(r.id) }

  def available_banners
    if campaign_banner_ids.empty?
      Banner.all
    else
      Banner.where('id NOT in (?)', campaign_banners.pluck(:banner_id))
    end
  end
end
