FactoryBot.define do
  factory :user_role do
    project
    user { User.last }
    role { 1 }
  end
end
