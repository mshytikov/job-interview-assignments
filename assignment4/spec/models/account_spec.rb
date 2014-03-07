require 'spec_helper'

describe Account do
  describe ".new" do
    its(:balance) { should be_zero }
  end

  describe "#save" do
    let(:account) { FactoryGirl.create(:user).account }

    context "with negative balance" do
      before { account.balance = -1 }
      context "skip validation" do
        it "raises error" do
          expect { account.save(false) }.to raise_error
        end
      end

      context "with validation" do
        it "returns false" do
          account.save.should be_false
        end
      end
    end

    context "with float balance" do
      before { account.balance = 1.1 }
      context "with validation" do
        it "returns false" do
          account.save.should be_false
        end
      end
    end
  end
end
