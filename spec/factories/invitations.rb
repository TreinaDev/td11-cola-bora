FactoryBot.define do
  factory :invitation do
    due_date { '2024-01-23' }
    project { nil }
    email { 'MyString' }
  end
end
