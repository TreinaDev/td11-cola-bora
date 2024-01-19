FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@email.com" }
    cpf { '000.000.001-91' }
    password { 'password' }
  end
end
