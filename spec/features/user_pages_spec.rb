require 'spec_helper'

describe "User Profile" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let(:to_user) { FactoryGirl.create(:user) }
  before { login!(user) }

  describe "profile page" do
    before { visit user_path(user) }

    it { should have_title('Profile') }
    it { should have_selector('h1', text: user.id) }

    it { should have_field('transfer_to_user_id') }
    it { should have_field('transfer_amount') }

    it_behaves_like "page without errors" 
  end

  describe "transfer" do
    let!(:balance) { user.balance }
    before do
      fill_in "To User ID",    with: to_user.id
      fill_in "Amount",        with: 10
      click_button "Transfer"
    end

    it_behaves_like "page without errors" 
    it { should  have_selector("h2", text: "Balance: #{balance - 10}") }
    it { should have_notice_message('Successfully transfered 10') }
  end
end
