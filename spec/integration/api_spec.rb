require 'spec_helper'
require 'multipart_body'

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
    it "responds with uuid in json" do
      with_api(Api) do
        get_request(:path => '/uuid.json') do |c|
          c.response_header.status.should == 200
          resp = from_json(c.response)
          resp.should be_instance_of Hash
          resp.should have_key('uuid')
          resp.should have(1).pair
          resp['uuid'].should =~ /\A\w{8}-\w{4}-\w{4}-\w{4}-\w{12}\z/ #very simple regexp for uuid format test
        end
      end
    end

    it "responds new uuid each time" do
      first_uuid = second_uuid = nil
      with_api(Api) do
        get_request(:path => '/uuid.json'){|c| first_uuid = from_json(c.response)['uuid'] }
      end
      with_api(Api) do
        get_request(:path => '/uuid.json'){|c| second_uuid = from_json(c.response)['uuid'] }
      end

      first_uuid.should_not eq(second_uuid)
    end
  end

  describe "GET /uploads/:filename" do
    it "should returns file from uploads dir"  do
      with_api(Api) do
        get_request(:path => '/uploads/test-non-uuid-file-txt') do |c| 
          c.response_header.status.should == 200
          c.response.should == "This is test uploaded file\n"
        end
      end
    end
  end

  describe "POST /upload" do
    describe "successful case" do
      let(:uuid){ SecureRandom.uuid }
      let(:expected_url){ "http://localhost:9900/uploads/#{uuid}" }
      let(:api_options){ {:log_file => "log/test.log" }}
      let(:body){ MultipartBody.new(file_uuid: uuid ,file: File.new('./spec/fixtures/files/upload1.txt')) }
      let(:head) { {'Content-Type' => "multipart/form-data; boundary=#{body.boundary}"} }

      it "should upload file" do
        with_api(Api, api_options) do
          post_request({path: '/upload', body: body.to_s, head: head}, err) do |c|
            c.response_header.status.should == 201
            c.response_header["Location"].should == expected_url

            resp = from_json(c.response)

            resp.should be_instance_of Hash
            resp.should have(1).pair
            resp.should have_key('url')
            resp['url'].should == expected_url
          end
        end
      end

      it "uploaded file should be valid and accesible by url" do
        url_to_file = nil
        with_api(Api, api_options) do
          post_request({path: '/upload', body: body.to_s, head: head}, err) do |c|
            c.response_header.status.should == 201
            url_to_file = c.response_header["Location"]
          end
        end

        file_content = nil
        with_api(Api) do |api| 
          path = url_to_file.sub(api.config[:server_url], '')
          get_request(:path => path) do |c|
            c.response_header.status.should == 200
            file_content = c.response  
          end
        end

        file_content.should == "UPLOAD_TEST1\n"
      end
    end

    describe "unsuccessful case" do
      it "should raise exception on unregistred uuid" do
        pending "UUID filtering should be added"
      end
    end

  end

  describe "GET /progress/:filename" do
    it "returns correct  progress for uploaded file" do
      with_api(Api) do
        get_request(:path => '/progress/test-non-uuid-file-txt') do |c| 
          c.response_header.status.should == 200
          resp = from_json(c.response)
          resp.should == { 'state' => 'done' }
        end
      end
    end
  end

end
