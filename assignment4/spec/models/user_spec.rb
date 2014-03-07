require 'spec_helper'

describe User do
  describe ".create" do
    let(:email)    { FactoryGirl.generate(:email) }
    let(:password) { FactoryGirl.generate(:password) }

    subject { User.create(email: email, password: password) }

    context "email and password are valid" do
      it { should have(:no).errors }
      its(:account) { should_not be_nil }
      its(:balance) { should be_zero}
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

  describe ".build_transfer with valid params" do
    let(:amount)  { 10 }
    let(:user)    { FactoryGirl.create(:user, balance: 100) }
    let(:to_user) { FactoryGirl.create(:user) }

    subject { user.build_transfer(to_user, amount) }
    it { should be_instance_of Transfer }
    its(:save) { should be_true }
  end
end
