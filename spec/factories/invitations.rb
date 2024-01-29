FactoryBot.define do
  factory :invitation do
    expiration_days { 10 }
    project
    profile_id { 1 }
  end
end
