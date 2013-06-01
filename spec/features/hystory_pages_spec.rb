require 'spec_helper'

describe "Transfers Hystory" do
  subject { page }
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  before do
    login!(user1)
    fill_in "To User ID",    with: user2.id
    fill_in "Amount",        with: 10
    click_button "Transfer"
    click_link "Sign out"

    login!(user2)
    fill_in "To User ID",    with: user1.id
    fill_in "Amount",        with: 20
    click_button "Transfer"
  end


  describe "hystory page" do
    before { visit transfers_path }

    it { should have_title('Hystory') }
    it { should have_selector('h1', text: user2.id) }
    it { should have_selector('h2', text: 90) }

    it { should have_selector('td', text: user1.id ) }
    it { should have_selector('td', text: user2.id ) }

    it { should have_selector('td', text: "10" ) }
    it { should have_selector('td', text: "20" ) }

    it { should have_selector('td', text: "110" ) }
    it { should have_selector('td', text: "90" ) }

  end
end
