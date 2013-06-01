require 'spec_helper'

describe "User Profile" do
  subject { page }
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { login!(user) }
    before { visit user_path(user) }

    it { should have_title('Profile') }
    it { should have_selector('h1', text: user.id) }

    it_behaves_like "page without errors" 
  end
end
