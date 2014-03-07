require 'spec_helper'

describe Transfer do

  describe ".save" do
    let(:account)    { FactoryGirl.create(:user).account }
    let(:to_account) { FactoryGirl.create(:user).account }

    context "with transfer to same account" do
      let(:transfer) { FactoryGirl.build(:transfer, account: account, to_account: account  ) }

      context "without validation" do
        it "raises error" do
          expect { transfer.save(false) }.to raise_error
        end
      end
    end

    context "with negative amount" do
      let(:amount)   { -1 }
      let(:transfer) { FactoryGirl.build(:transfer, amount: amount, account: account, to_account: to_account) }

      context "with validation" do
        it "returns false" do
          transfer.save.should be_false
        end

        it "has error on amount" do
          transfer.save
          transfer.should have(1).error_on(:amount)
        end
      end
    end

    describe "funds transfer" do
      let(:amount)   { 1 }
      let(:transfer) { FactoryGirl.build(:transfer, amount: amount, account: account, to_account: to_account) }

      context "successful" do
        it { transfer.save.should be_true}
        it "increases distanation account" do
          expect { transfer.save }.to change { to_account.reload.balance }.by(amount)
        end
        it "decreases source account" do
          expect { transfer.save }.to change { account.reload.balance    }.by(-amount)
        end
      end
    end
  end
end
