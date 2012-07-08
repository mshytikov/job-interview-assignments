require 'spec_helper'
require 'multipart_body'

describe Api do
  let(:err) { Proc.new { fail "API request failed" } }
  let(:api_options){ {:log_file => "log/test.log" }}

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

  describe "POST /upload/:file_uuid" do
    describe "successful case" do
      let(:uuid){ SecureRandom.uuid }
      let(:expected_url){ "http://localhost:9900/uploads/#{uuid}.txt" }
      let(:body){ MultipartBody.new(file: File.new('./spec/fixtures/files/upload1.txt')) }
      let(:head) { {'Content-Type' => "multipart/form-data; boundary=#{body.boundary}"} }

      it "should upload file" do
        with_api(Api, api_options) do
          post_request({path: "/upload/#{uuid}", body: body.to_s, head: head}, err) do |c|
            c.response_header.status.should == 201
            c.response_header["Location"].should == expected_url
            c.response.should include("<div id='state'>compleated</div>")
            c.response.should include("id='file_url' href='#{expected_url}'")
          end
        end
      end

      it "uploaded file should be valid and accesible by url" do
        url_to_file = nil
        with_api(Api, api_options) do
          post_request({path: "/upload/#{uuid}", body: body.to_s, head: head}, err) do |c|
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
      it "returns Method Not Allowed  on GET" do
        with_api(Api) do
          get_request({path: '/upload/some-uuid'}, err) do |c|
            c.response_header.status.should == 405
          end
        end
      end

      it "should raise exception on unregistred uuid" do
        pending "UUID filtering should be added"
      end
    end

  end

  describe "GET /progress/:file_uuid" do
    describe "successful case" do
      let(:uuid) {SecureRandom.uuid }
      let(:body){ MultipartBody.new(file: File.new('./spec/fixtures/files/upload1.txt')) }
      let(:head) { {'Content-Type' => "multipart/form-data; boundary=#{body.boundary}"} }
      let(:upload_data){{path: "/upload/#{uuid}", body: body.to_s, head: head} }
      let(:expected_size) { body.to_s.bytesize }

      it "returns correct  progress for uploaded file" do
        with_api(Api, api_options) do
          get_request(:path => '/progress/test-non-uuid-file-txt') do |c| 
            c.response_header.status.should == 200
            resp = from_json(c.response)
            resp.should == { 'state' => 'done' }
          end
        end
      end
      it "returns correct  progress for upload in progress" do
        with_api(Api, api_options) do
          conn = create_test_request(upload_data)
          conn.extend(SuperUpload::SendDataHook)
          req = conn.aget(upload_data)
          #This commented due to fail when second call terminates
          #req.errback &err
          #req.errback { stop }

          get_request({:path => "/progress/#{uuid}"}, err) do |c|
            c.response_header.status.should == 200
            resp = from_json(c.response)
            resp.should == { 'state' => 'uploading', 'received' => expected_size/2, 'size' => expected_size }
            #conn.release_send_data!
          end
        end
      end
    end
    describe "unsuccessful case"  do
      describe "not registred upload" do
        it "should returns Not Found " do
          with_api(Api) do
            get_request({path: "/progress/not-registred-uuid"}, err) do |c|
              c.response_header.status.should == 404
            end
          end
        end
      end
    end
  end

end
