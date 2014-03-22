class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.integer :ratio_random
      t.integer :ratio_weighted

      t.timestamps
    end
  end
end
