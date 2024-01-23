FactoryBot.define do
  factory :meeting do
    user_role { nil }
    title { 'MyString' }
    description { 'MyString' }
    datetime { '2024-01-23T14:00:00' }
    duration { 1 }
    address { 'MyString' }
  end
end
