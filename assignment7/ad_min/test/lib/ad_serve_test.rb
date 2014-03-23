require 'test_helper'

# Simple tests for AdServe
class AdServeTest < ActiveSupport::TestCase

  test "should provide API methods" do
    assert AdServe.respond_to?(:save_banner)
    assert AdServe.respond_to?(:delete_banner)
    assert AdServe.respond_to?(:save_campaign)
    assert AdServe.respond_to?(:delete_campaign)
  end

  test "should raise exception when connection url is nil" do
    assert_raises(RuntimeError){ AdServe.connect(nil) }
   end

  test "should always respond with success when url is :tets" do
     AdServe.connect(:test)
     assert AdServe.save_banner(1,1, "url", 10)
     assert AdServe.delete_banner(1,1)
     assert AdServe.save_campaign(1, 10, 10)
     assert AdServe.delete_campaign(1)
   end

  test "should raise exception when disconnected" do
     AdServe.disconnect
     assert_raises(RuntimeError) { AdServe.delete_campaign(1,1) }
  end

end

class AdClientTest< ActiveSupport::TestCase
  setup do
    @client = AdServe::Client.new(nil)
  end

  test "#api_path" do
    assert_equal("campaigns/1", @client.api_path(1))
    assert_equal("campaigns/1/banners/2", @client.api_path(1,2))
  end

  test "#process_response" do
    with_status = ->(status){ AdServe::TestConnection::Response.new(status) }

    assert_equal(true, @client.process_response(with_status[201]))
    assert_equal(true, @client.process_response(with_status[204]))
    assert_equal(false, @client.process_response(with_status[200]))
    assert_equal(false, @client.process_response(with_status[500]))
  end
end
