FactoryBot.define do
  factory :comment do
    content { "MyText" }
    post { nil }
    user_role { nil }
  end
end
