class Campaign < ActiveRecord::Base
  has_many :campaign_banners, dependent: :destroy
end
