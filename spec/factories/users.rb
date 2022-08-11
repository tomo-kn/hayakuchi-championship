FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Joe#{n}" }
    sequence(:email) { |m| "rspec#{m}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
