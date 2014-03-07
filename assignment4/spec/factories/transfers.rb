# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transfer do
    amount
    to_account_id { FactoryGirl.create(:user).account.id }
    account_id    { FactoryGirl.create(:user).account.id }
  end
end
