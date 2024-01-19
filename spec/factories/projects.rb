FactoryBot.define do
  factory :project do
    user
    title { 'MyString' }
    description { 'MyText' }
    category { 'MyString' }
  end
end
