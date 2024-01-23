FactoryBot.define do
  factory :meeting do
    user_role { nil }
    title { "MyString" }
    description { "MyString" }
    date { "2024-01-23" }
    time { "2024-01-23 12:00:05" }
    duration { 1 }
    address { "MyString" }
  end
end
