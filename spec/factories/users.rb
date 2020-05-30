FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}"}
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
    activated { true }
    activated_at { Time.zone.now }
  end
end
