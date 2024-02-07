FactoryBot.define do
  factory :user_role do
    project { nil }
    user
    role { :contributor }
  end
end
