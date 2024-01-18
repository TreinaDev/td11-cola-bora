FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    project { nil }
    user { nil }
    due_date { "2024-01-18" }
    assigned { "MyString" }
  end
end
