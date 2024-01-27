FactoryBot.define do
  factory :document do
    user
    project { create(:project, user:) }
    title { 'Documento Teste' }
    description { 'Descrição teste' }
    file { Rails.root.join('spec/support/files/sample_jpg.jpg') }
    archived { false }
  end
end
