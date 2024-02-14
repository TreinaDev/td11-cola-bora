FactoryBot.define do
  factory :post do
    title { 'A arte de criar' }
    body { 'Estive desenvolvendo um novo método para acelerar a resolução de tarefas do projeto' }
    user_role { nil }
    project { nil }
  end
end
