FactoryBot.define do
  factory :user do
    cpf { '757.113.930-90' }
    email { 'usuario@email.com' }
    password { '123456' }
  end
end
