FactoryBot.define do
  factory :project do
    user { nil }
    title { "MyString" }
    description { "MyText" }
    category { "MyString" }
  end
end
