FactoryBot.define do
  factory :profile do
    user { nil }
    first_name { 'MyString' }
    last_name { 'MyString' }
    work_experience { 'MyText' }
    education { 'MyText' }
  end
end
