require 'carrierwave/orm/activerecord'
class Banner < ActiveRecord::Base
  mount_uploader :image, BannerUploader
end
