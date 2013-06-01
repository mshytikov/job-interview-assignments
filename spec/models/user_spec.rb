require 'spec_helper'

describe User do
  describe ".create" do
    subject { User.create(email: email, password: password) }

    context "email is blank" do
      let(:email) { nil }
      it { should have(1).error_on(:email) }
    end

    context "password is blank" do
      let(:email) { nil }
      it { should have(1).error_on(:password) }
    end

    context "email already exists" do
      before { FactoryGirl.create(:user, email: email) }
      it { should have(1).error_on(:base) }
    end

  end
end
