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


end
