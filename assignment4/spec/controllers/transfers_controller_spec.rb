require 'spec_helper'

describe TransfersController do

  describe "POST 'create'" do
    context "user not signed in" do
      it "returns http redirect" do
        post 'create', :transfer => { :to_user_id => 1, :amount => 10 }
        response.should be_redirect
      end
    end
  end

end
