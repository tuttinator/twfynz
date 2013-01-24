FactoryGirl.define do

  sequence(:email) { |n| "unique#{n}@example.com" }


  factory :user do
    email
    password "secretsecretsecret"
    # this pattern allows for defaulting the password_confirmation to match a supplied password
    password_confirmation { |u| u.password }
  end


end