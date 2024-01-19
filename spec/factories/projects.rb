FactoryBot.define do
  factory :project do
    user
    sequence(:title) { |n| "Padrão #{n}" }
    sequence(:description) { |n| "Descrição de um projeto padrão para testes #{n}." }
    category { 'Categoria de projeto' }
  end
end
