FactoryBot.define do
  factory :user_role do
    project
    user { User.last }
    role { :contributor }
  end
end
