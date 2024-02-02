FactoryBot.define do
  factory :invitation do
    expiration_days { 10 }
    project
    sequence(:profile_id) { |n| n }
    sequence(:profile_email) { |_n| 'invited@email.com' }
  end
end
