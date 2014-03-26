# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

campaign = Campaign.create({ratio_random: 60, ratio_weighted: 40})

Dir[Rails.root.join('tests', 'fixtures', 'banners', '*.png')].each do |f|
  puts f
  Banner.create(name: File.basename(f), image: File.open(f))
end

Banner.all.each.with_index do |banner, i|
  CampaignBanner.create(campaign: campaign, banner: banner, weight: i)
end

puts "="*50
puts "Generated data for Campaign id: #{campaign.id}"
