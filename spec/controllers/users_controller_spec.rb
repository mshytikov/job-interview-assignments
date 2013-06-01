require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do
    context "user not signed in" do
      it "returns http redirect" do
        get 'show'
        response.should be_redirect
      end
    end
  end

end
