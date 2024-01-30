FactoryBot.define do
  factory :invitation do
    expiration_days { 10 }
    project
    profile_id { 1 }
    sequence(:profile_email) { |n| "usuario#{n}@email.com" }
  end
end
