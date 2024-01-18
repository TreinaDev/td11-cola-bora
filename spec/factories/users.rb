FactoryBot.define do
  factory :user do
    email { 'user@email.com' }
    cpf { '837.513.746-47' }
    password { 'password' }
  end
end
