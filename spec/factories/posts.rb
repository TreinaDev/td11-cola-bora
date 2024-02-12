FactoryBot.define do
  factory :post do
    title { "MyString" }
    body { "MyString" }
    user_role { nil }
    project { nil }
  end
end
