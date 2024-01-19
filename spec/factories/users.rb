FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@email.com" }
    cpf { '837.566.746-47' }
    password { 'password' }
  end
end
