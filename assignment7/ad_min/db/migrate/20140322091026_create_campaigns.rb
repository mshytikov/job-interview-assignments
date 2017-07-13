class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.integer :ratio_random, null: false, default: 0
      t.integer :ratio_weighted, null:false, default: 0

      t.timestamps
    end
  end
end
