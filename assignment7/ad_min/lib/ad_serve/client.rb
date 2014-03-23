require 'faraday'

# Simple HTTP client to conmmunicate with AdServe
class AdServe
  class << self
    def save_campaign(id, raindom, weighted)
      params = {random: random, weighted: weighted}
      process_response @conn.put(url(id), params)
    end

    def delete_campaign(id)
      process_response @conn.delete(url(id))
    end

    def save_banner(id, campaign_id, url, weight)
      params = {url: url, weight: weight}
      process_response @conn.put(url(campaign_id, id), params)
    end

    def delete_banner(id, campaign_id)
      process_response @conn.delete(url(campaign_id, id))
    end

    # Simple response handling
    def process_response(resp)
      [201, 204].include?(resp.status)
    end

    def api_url(campaign_id, banner_id)
      path = ['campaigns', campaign_id]
      path += ['banners', banner_id] if banner_id
      path.join("/")
    end

    def connect(url)
      @conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

  end
end
