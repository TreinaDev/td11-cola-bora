FactoryBot.define do
  factory :proposal do
    project
    status { :pending }
    message { 'Mensagem padrão' }
    sequence(:profile_id) { |n| n }
    # sequence(:email) { |n| "proposer#{n}@email.com" }
  end
end
