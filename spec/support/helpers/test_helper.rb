module SuperUpload
  module TestHelper
    def from_json(body)
      json = nil
      lambda { json = MultiJson.load(body) }.should_not raise_error
      json
    end
  end
end
