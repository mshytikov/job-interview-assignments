require 'spec_helper'

describe Transfer do

  describe ".save" do

    context "with transfer to same account" do
      let(:account) { FactoryGirl.build(:user).account }
      let(:transfer) { FactoryGirl.build(:transfer, account: account, to_account: account  ) }
      context "without validation" do
        it "raises error" do
          expect { transfer.save(false) }.to raise_error
        end
      end
    end

    context "with negative amount" do
      let(:amount) { -1 }
      let(:transfer) { FactoryGirl.build(:transfer, amount: amount) }
      context "with validation" do
        it "returns false" do
          transfer.save.should be_false
        end
      end
    end
  end
end
