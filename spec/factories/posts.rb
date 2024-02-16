FactoryBot.define do
  factory :post do
    title { 'A arte de criar' }
    body { 'Estive desenvolvendo um novo método para acelerar a resolução de tarefas do o projeto' }
    user_role
    project
  end
end
