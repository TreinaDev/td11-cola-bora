FactoryBot.define do
  factory :document do
    user { nil }
    project { nil }
    title { 'Documento Teste' }
    description { 'Descrição teste' }
    file { nil }
    archived { false }
  end
end
