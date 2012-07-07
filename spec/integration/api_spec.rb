require 'spec_helper'

describe Api do
  let(:err) { Proc.new { fail "API request failed" } }

  it 'returns "Hello world" ' do
    with_api(Api) do
      get_request({}, err) do |c|
        c.response.should == 'Hello World'
      end
    end
  end
end
