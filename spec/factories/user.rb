FactoryGirl.define do
  factory :user do
    email
    password
    account { FactoryGirl.build(:account) }
  end
end
