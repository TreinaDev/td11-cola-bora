FactoryBot.define do
  factory :user_role do
    user { nil }
    project { nil }
    role { 1 }
  end
end
