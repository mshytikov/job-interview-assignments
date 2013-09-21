require 'spec_helper'

describe ConvertersController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'convert'" do
    it "returns http success" do
      get 'convert'
      response.should be_success
    end
  end

end
