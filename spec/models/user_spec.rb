require 'spec_helper'

describe User do
  describe ".create" do
    let(:email) { FactoryGirl.generate(:email) }
    let(:password) { FactoryGirl.generate(:password) }

    subject { User.create(email: email, password: password) }

    context "email and password are valid" do
      it { should have(:no).errors }
    end

    context "email is blank" do
      let(:email) { "" }
      it { should have(1).error_on(:email) }
    end

    context "password is blank" do
      let(:password) { "" }
      it { should have(1).error_on(:password) }
    end

    context "email already exists" do
      before { FactoryGirl.create(:user, email: email) }
      it { should have(1).error_on(:email) }
    end


  end
end
