require 'faraday'

# Simple HTTP client to conmmunicate with AdServe
module AdServe
  extend SingleForwardable

  # Forward API calls to AdServe::Client instance
  def_delegators :client, :save_campaign, :delete_campaign, :save_banner, :delete_banner

  class << self

    # This method should be called once on App configuration
    # It creates connection and instantiate the global client
    # If called with :test then `TestConnection` is used
    def connect(url)
      raise "Please provide AdServe url: config.ad_serve_url" unless url
      if :test == url
        connection = TestConnection.new()
      else
        connection = Faraday.new(:url => url) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
      end

      self.client = Client.new(connection)
    end

    def disconnect
     @client = nil
    end

    def client
      @client || raise("Connection not established")
    end

    # This needed only for testing purposes.
    def client=(client)
      @client = client
    end
  end

  # Client object provides API for AdServe
  class Client
    attr_accessor :connection

    def initialize(connection)
      self.connection = connection
    end
    def save_campaign(id, random, weighted)
      params = {random: random, weighted: weighted}
      process_response connection.put(api_path(id), params)
    end

    def delete_campaign(id)
      process_response connection.delete(api_path(id))
    end

    def save_banner(id, campaign_id, url, weight)
      params = {url: url, weight: weight}
      process_response connection.put(api_path(campaign_id, id), params)
    end

    def delete_banner(id, campaign_id)
      process_response connection.delete(api_path(campaign_id, id))
    end

    # Simple response handling
    def process_response(resp)
      [201, 204].include?(resp.status) || raise("Invalid AdServe response")
    end

    # Helper function to generate api path
    def api_path(campaign_id, banner_id = nil)
      path = ['campaigns', campaign_id]
      path += ['banners', banner_id] if banner_id
      path.join("/")
    end
  end

  # This class used in test to dissable real connection
  # Always respond with success
  class TestConnection
    Response = Struct.new(:status)

    def put(*args)
      Response.new(204)
    end

    def delete(*args)
      Response.new(204)
    end
  end

end
