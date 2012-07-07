require 'spec_helper'

describe Api do
  let(:err) { Proc.new { fail "API request failed" } }


  describe "GET /" do
    it 'returns "Hello world"' do
      with_api(Api) do
        get_request({}, err) do |c|
          c.response_header.status.should == 200
          c.response.should == 'Hello World'
        end
      end
    end
  end

  describe "GET /super_upload.html" do
    it 'renders a static super upload form' do
      with_api(Api) do
        get_request(:path => '/super_upload.html') do |c|
          c.response_header.status.should == 200
          c.response.should =~ %r{Super Upload}
        end
      end
    end
  end


  describe "GET /uuid.json" do
    it "responds new uuid" do
      with_api(Api) do
        get_request(:path => '/uuid.json') do |c|
          c.response_header.status.should == 200
          resp = from_json(c.response)
          resp.should be_instance_of Hash
          resp.should have_key("uuid")
          resp.should have(1).pair
          resp[:uuid].should == /\A\w{8}-\w{4}-\w{4}-\w{4}-\w{12}\z/ #very simple regexp for uuid format test
        end
      end
    end
  end
end
