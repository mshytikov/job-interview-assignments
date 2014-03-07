module FeaturesHelper
  include ApplicationHelper

  def login!(user)
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  RSpec::Matchers.define :have_error_message do |message|
    match do |page|
      expect(page).to have_selector('div.alert.alert-error', text: message)
    end
  end

  RSpec::Matchers.define :have_notice_message do |message|
    match do |page|
      expect(page).to have_selector('div.alert.alert-notice', text: message)
    end
  end

end
