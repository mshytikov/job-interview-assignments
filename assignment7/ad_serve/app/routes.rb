#
# Public API available for Visitors
#
get '/campaigns/:id/users/:user_id/next_banner' do
  url = Campaign.new(params[:id]).get_next_banner(params[:user_id])
  url ||= settings.default_banner_url
  redirect url , 302
end


#
# Private API available for AdMin
#
put '/campaigns/:id' do
  Campaign.new(params[:id]).save(params[:random].to_i, params[:weighted].to_i)
  status 204
end

delete '/compaigns/:id' do
  Campaign.new(params[:id]).delete
  status 204
end

put '/compaigns/:id/banners/:banner_id' do
  Campaign.new(params[:id]).save_banner(params[:banner_id], params[:url], params[:weight])
  status 204
end

delete '/compaigns/:campaign_id/banners/:id' do
  Campaign.new(params[:id]).delete_banner(params[:banner_id])
  status 204
end
