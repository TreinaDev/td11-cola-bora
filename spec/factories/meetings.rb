FactoryBot.define do
  factory :meeting do
    project
    user_role { UserRole.last }
    title { 'Alinhamento de estratégia' }
    description { 'Reunião para alinhar a estratégia da equipe' }
    datetime { 2.days.from_now.to_datetime }
    duration { 60 }
    address { 'Sala 5' }
  end
end
