class CreateCampaignBanners < ActiveRecord::Migration
  def change
    create_table :campaign_banners do |t|
      t.references :campaign, index: true
      t.references :banner, index: true
      t.integer :weight

      t.timestamps
    end
  end
end
