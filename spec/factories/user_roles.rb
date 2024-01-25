FactoryBot.define do
  factory :user_role do
    user
    project
    role { 1 }
  end
end
