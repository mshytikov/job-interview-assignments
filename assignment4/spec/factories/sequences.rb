FactoryGirl.define do 

  sequence :email do |n|
    "test#{n}@test.com"
  end

  sequence :password do |n|
    "password_#{n}"
  end

  sequence :amount do |n|
    n+1
  end

end
