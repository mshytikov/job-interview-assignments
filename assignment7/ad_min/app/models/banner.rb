require 'carrierwave/orm/activerecord'
class Banner < ActiveRecord::Base
  mount_uploader :image, BannerUploader
  has_many :campaign_banners, dependent: :destroy
end
