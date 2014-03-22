# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140322104042) do

  create_table "banners", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_banners", force: true do |t|
    t.integer  "campaign_id"
    t.integer  "banner_id"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaign_banners", ["banner_id"], name: "index_campaign_banners_on_banner_id"
  add_index "campaign_banners", ["campaign_id"], name: "index_campaign_banners_on_campaign_id"

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.integer  "ratio_random"
    t.integer  "ratio_weighted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
