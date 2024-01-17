FactoryBot.define do
  factory :user do
    email { 'user@mail.com' }
    password { '123456' }
    cpf { '916.219.630-80' }
  end
end
