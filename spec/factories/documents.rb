FactoryBot.define do
  factory :document do
    user { nil }
    project { nil }
    title { "MyString" }
    description { "MyText" }
    file { nil }
    archived { false }
  end
end
